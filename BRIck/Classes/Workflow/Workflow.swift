//
//  Workflow.swift
//  BRIck
//
//  Created by Artem Orynko on 11/23/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//
// Based on https://github.com/vadymmarkov/When

import Foundation

open class Workflow<ActionableItemType> {
    public typealias BecomeActiveHandler = () -> Void
    public typealias DoneHandler = (ActionableItemType) -> Void
    public typealias FailureHandler = (Error) -> Void
    public typealias CompletionHandler = (WorkflowResult<ActionableItemType>) -> Void

    fileprivate(set) var becomeActiveHandlers: [BecomeActiveHandler] = []
    fileprivate(set) var doneHandlers: [DoneHandler] = []
    fileprivate(set) var failureHandlers: [FailureHandler] = []
    fileprivate(set) var completionHandlers: [CompletionHandler] = []

    public fileprivate(set) var state: WorkflowState<ActionableItemType>

    fileprivate let observerQueue: DispatchQueue = DispatchQueue(label: "workflow.observer.queue")
    private var _observer: WorkflowObserver<ActionableItemType>?
    fileprivate(set) var observer: WorkflowObserver<ActionableItemType>? {
        get {
            return observerQueue.sync {
                return _observer
            }
        }
        set {
            observerQueue.sync {
                _observer = newValue
            }
        }
    }

    let queue: DispatchQueue

    // MARK: - Initialization

    /// Create a workflow with a given state
    public init(queue: DispatchQueue = .global(qos: .background),
                state: WorkflowState<ActionableItemType> = .pending) {
        self.queue = queue
        self.state = state

        becomeActive()
    }

    /// Create a workflow that resolves using a synchronous closure.
    public convenience init(queue: DispatchQueue = .global(qos: .background),
                            _ closure: @escaping () throws -> ActionableItemType) {
        self.init(queue: queue, state: .pending)
        dispatch(queue) {
            do {
                let value = try closure()
                self.resolve(value)
            } catch {
                self.reject(error)
            }
        }
    }

    /// Create a workflow that resolves using an asynchronous closure that can either resolve or reject.
    public convenience init(queue: DispatchQueue = .global(qos: .background),
                            _ closure: @escaping (_ resolve: (ActionableItemType) -> Void, _ reject: (Error) -> Void) -> Void) {
        self.init(queue: queue, state: .pending)
        dispatch(queue) {
            closure(self.resolve, self.reject)
        }
    }

    /// Create a workflow that resolves using an asynchronous closure that can only resolve.
    public convenience init(queue: DispatchQueue = .global(qos: .background),
                            _ closure: @escaping (@escaping (ActionableItemType) -> Void) -> Void) {
        self.init(queue: queue, state: .pending)
        dispatch(queue) {
            closure(self.resolve)
        }
    }

    // MARK: - States

    /// Resjects a workflow with a given error.
    public final func reject(_ error: Error) {
        guard self.state.isPending else {
            return
        }

        let state: WorkflowState<ActionableItemType> = .rejected(error: error)
        update(state: state)
    }

    /// Resolves a workflow with a given value.
    public final func resolve(_ value: ActionableItemType) {
        guard self.state.isPending else {
            return
        }

        let state: WorkflowState<ActionableItemType> = .resolved(value: value)
        update(state: state)
    }

    /// Reject a workflow with the cancelled error.
    open func cancel() {
        reject(WorkflowError.cancelled)
    }

    // MARK: - Callbacks

    /// Adds a handler to be called when the workflow object will become active.
    @discardableResult
    public final func becomeActive(_ handler: @escaping BecomeActiveHandler) -> Self {
        becomeActiveHandlers.append(handler)

        return self
    }

    /// Adds a handler to be called when the workflow object is resolved with a value.
    @discardableResult
    public final func onFinished(_ handler: @escaping DoneHandler) -> Self {
        doneHandlers.append(handler)

        return self
    }

    /// Adds a handler to be called when the workflow object is rejected with an error.
    @discardableResult
    public final func onError(policy: FailurePolicy = .notCancelled,
                     _ handler: @escaping FailureHandler) -> Self {
        let failureHandler: FailureHandler = { error in
            if case WorkflowError.cancelled = error, policy == .notCancelled {
                return
            }
            handler(error)
        }
        failureHandlers.append(failureHandler)

        return self
    }

    /// Adds a handler to be called when the workflow object is either resolved or rejected.
    /// This callback will be called after done or fail handlers.
    @discardableResult
    public final func always(_ handler: @escaping CompletionHandler) -> Self {
        completionHandlers.append(handler)

        return self
    }

    // MARK: - Helpers

    fileprivate func update(state: WorkflowState<ActionableItemType>?) {
        dispatch(queue) {
            guard let state = state, let result = state.result else {
                return
            }

            self.state = state
            self.notify(result)
        }
    }

    private func notify(_ result: WorkflowResult<ActionableItemType>) {
        switch result {
        case let .success(value): doneHandlers.forEach { $0(value) }
        case let .failure(error): failureHandlers.forEach { $0(error) }
        }

        completionHandlers.forEach { $0(result) }

        if let observer = observer {
            dispatch(observer.queue) {
                observer.notify(result)
                self.observer = nil
            }
        }

        doneHandlers.removeAll()
        failureHandlers.removeAll()
        completionHandlers.removeAll()
    }

    // MARK: - Private Methods

    private func dispatch(_ queue: DispatchQueue, closure: @escaping () -> Void) {
        queue.async(execute: closure)
    }

    private func becomeActive() {
        dispatch(queue) {
            self.becomeActiveHandlers.forEach { $0() }
            self.becomeActiveHandlers.removeAll()
        }
    }
}

// MARK: - onStep

extension Workflow {

    @discardableResult
    public func onStep<NextActionableItemType>(on queue: DispatchQueue = .global(qos: .background),
                                               _ onStep: @escaping (ActionableItemType) throws -> NextActionableItemType) -> Workflow<NextActionableItemType> {
        let workflow = Workflow<NextActionableItemType>(queue: queue)
        addObserver(on: queue, workflow: workflow, onStep)

        return workflow
    }

    @discardableResult
    public func onStep<NextActionableItemType>(on queue: DispatchQueue = .global(qos: .background),
                                               _ onStep: @escaping (ActionableItemType) throws -> Workflow<NextActionableItemType>) -> Workflow<NextActionableItemType> {
        let workflow = Workflow<NextActionableItemType>(queue: queue)
        addObserver(on: queue, workflow: workflow) { value -> NextActionableItemType? in
            let nextWorkflow = try onStep(value)
            nextWorkflow.addObserver(on: queue, workflow: workflow, { value -> NextActionableItemType? in
                return value
            })

            return nil
        }

        return workflow
    }

    @discardableResult
    public func onStepInMain<NextActionableItemType>(_ onStep: @escaping (ActionableItemType) throws -> NextActionableItemType) -> Workflow<NextActionableItemType> {
        return self.onStep(on: .main, onStep)
    }

    @discardableResult
    public func onStepInMain<NextActionableItemType>(_ onStep: @escaping (ActionableItemType) throws -> Workflow<NextActionableItemType>) -> Workflow<NextActionableItemType> {
        return self.onStep(on: .main, onStep)
    }

    fileprivate func addObserver<NextActionableItemType>(on queue: DispatchQueue,
                                                         workflow: Workflow<NextActionableItemType>,
                                                         _ closure: @escaping (ActionableItemType) throws -> NextActionableItemType?) {
        observer = WorkflowObserver(queue: queue) { result in
            switch result {
            case let .success(value):
                do {
                    if let result = try closure(value) {
                        workflow.resolve(result)
                    }
                } catch {
                    workflow.reject(error)
                }
            case let .failure(error):
                workflow.reject(error)
            }
        }

        update(state: state)
    }
}
