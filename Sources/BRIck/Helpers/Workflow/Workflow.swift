//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Combine

/// Defines the base class for a sequence of steps that execute a flow through the application RIB tree.
///
/// At each step of a `Workflow` is a pair of value and actionable item. The value can be used to make logic decisions.
/// The actionable item is invoked to perform logic for the step. Typically the actionable item is the `Interactor` of a
/// RIB.
///
/// A workflow should always start at the root of the tree.
open class Workflow<ActionableItemType> {
    // MARK: - Private Properties

    private let subject = PassthroughSubject<(ActionableItemType, Void), Error>()
    private var didInvokeComplete = false

    // MARK: - Fileprivate Properties

    fileprivate var cancellableStore = Set<AnyCancellable>()

    // MARK: - Inits

    public init() {}

    // MARK: - Open Methods

    /// Called when the last step observable is completed.
    ///
    /// Subclasses should override this method if they want to execute logic at this point in the `Workflow` lifecycle.
    /// The default implementation does nothing.
    open func didComplete() {}

    /// Called when the `Workflow` is forked.
    ///
    /// Subclasses should override this method if they want to execute logic at this point in the `Workflow` lifecycle.
    /// The default implementation does nothing.
    open func didFork() {}

    /// Called when the last step observable is has error.
    ///
    /// Subclasses should override this method if they want to execute logic at this point in the `Workflow` lifecycle.
    /// The default implementation does nothing.
    open func didReceive(_ error: Error) {}

    // MARK: - Public Methods
    
    
    /// Subscribe and start the `Workflow` sequence.
    ///
    /// - parameter actionableItem: The initial actionable item for the first step.
    /// - returns: The disposable of this workflow.
    @discardableResult
    public final func subscribe(_ actionableItem: ActionableItemType) -> Set<AnyCancellable> {
        if cancellableStore.isEmpty {
            assertionFailure("Attempt to subscribe to \(self) before it is commited.")
        }
        
        subject.send((actionableItem, ()))
        
        return cancellableStore
    }


    /// Execute the given closure as the root step.
    ///
    /// - parameter next: The closure to execute for the root step.
    /// - returns: The next step.
    public final func on<NextActionableItemType, NextValueType>(
        next: @escaping (ActionableItemType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error>
    ) -> Step<ActionableItemType, NextActionableItemType, NextValueType> {
        Step(workflow: self, publisher: subject.prefix(1).eraseToAnyPublisher())
            .on { actionableItem, _ in
                next(actionableItem)
            }
    }

    // MARK: - Fileprivate Methods

    fileprivate final func didCompleteIfNeeded() {
        if didInvokeComplete { return }

        didInvokeComplete = true
        didComplete()
    }
}

/// Defines a single step in a `Workflow`.
///
/// A step may produce a next step with a new value and actionable item, eventually forming a sequence of `Workflow`
/// steps.
///
/// Steps are asynchronous by nature.
open class Step<WorkflowActionableItemType, ActionableItemType, ValueType> {
    // MARK: - Private Properties

    private let workflow: Workflow<WorkflowActionableItemType>
    private var publisher: AnyPublisher<(ActionableItemType, ValueType), Error>

    // MARK: - Inits

    fileprivate init(
        workflow: Workflow<WorkflowActionableItemType>,
        publisher: AnyPublisher<(ActionableItemType, ValueType), Error>
    ) {
        self.workflow = workflow
        self.publisher = publisher
    }

    // MARK: - Public Methods
    
    /// Executes the given closure for this step.
    ///
    /// - parameter next: The closure to execute for the `Step`.
    /// - returns: The next step.
    public final func on<NextActionableItemType, NextValueType>(
        next: @escaping (ActionableItemType, ValueType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error>
    ) -> Step<WorkflowActionableItemType, NextActionableItemType, NextValueType> {
        let confinedNextStep = publisher
            .map { actionableItem, value -> AnyPublisher<(Bool, ActionableItemType, ValueType), Error> in
                if let interactor = actionableItem as? Interactable {
                    return interactor
                        .isActiveStream
                        .map { isActive -> (Bool, ActionableItemType, ValueType) in
                            (isActive, actionableItem, value)
                        }
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return Just((true, actionableItem, value))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }

            .switchToLatest()
            .filter { isActive, _, _ -> Bool in isActive }
            .prefix(1)
            .map { _, actionableItem, value -> AnyPublisher<(NextActionableItemType, NextValueType), Error> in
                next(actionableItem, value)
            }
            .switchToLatest()
            .prefix(1)
            .share()
            .eraseToAnyPublisher()

        return Step<WorkflowActionableItemType, NextActionableItemType, NextValueType>(
            workflow: workflow,
            publisher: confinedNextStep
        )
    }
    
    public final func on(error: @escaping (Subscribers.Completion<Error>) -> Void) -> Step<WorkflowActionableItemType, ActionableItemType, ValueType> {
        publisher = publisher
            .handleEvents(receiveCompletion: error)
            .eraseToAnyPublisher()
        
        return self
    }
    
    @discardableResult
    public final func commit() -> Workflow<WorkflowActionableItemType> {
        publisher
            .handleEvents(receiveCompletion: { state in
                switch state {
                case .finished:
                    self.workflow.didCompleteIfNeeded()
                    
                case let .failure(error):
                    self.workflow.didReceive(error)
                }
            })
            .sink { _ in } receiveValue: { _ in }
            .store(in: &workflow.cancellableStore)

        return workflow
    }
}

extension Step: Publisher {
    public typealias Output = (ActionableItemType, ValueType)
    public typealias Failure = Error
    
    public func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, (ActionableItemType, ValueType) == S.Input {
        publisher.receive(subscriber: subscriber)
    }
    
    func eraseToAnyPublisher() -> AnyPublisher<(ActionableItemType, ValueType), Error> {
        publisher
    }
}

/// `Workflow` related publisher extensions.
public extension Publisher {
    /// Fork the step from this publisher.
    ///
    /// - parameter workflow: The workflow this step belongs to.
    /// - returns: The newly forked step in the workflow. `nil` if this observable does not conform to the required
    ///   generic type of (ActionableItemType, ValueType).
    func fork<WorkflowActionableItemType, ActionableItemType, ValueType>(
        _ workflow: Workflow<WorkflowActionableItemType>
    ) -> Step<WorkflowActionableItemType, ActionableItemType, ValueType>? {
        if let publisher = self.eraseToAnyPublisher() as? AnyPublisher<(ActionableItemType, ValueType), Error> {
            workflow.didFork()

            return Step(workflow: workflow, publisher: publisher)
        }

        return nil
    }
}

/// `Workflow` related `Cancellable` extension.
public extension Cancellable {
    /// Cancel the subscriber when the given `Workflow` is cancelled.
    ///
    /// When using this composition, the subscriber closure may freely retain workflow itself, since the
    /// subscriber closure is cancelled once the workflow is cancelled, thus releasing the retain cycle before the
    /// `Workflow` needs to be deallocated.
    ///
    /// - note: This is the preferred method when trying to confine a subscriber to the lifecycle of a `Workflow`.
    ///
    /// - parameter workflow: The workflow to cancel the subscriber with.
    func cancel<ActionableItemType>(with workflow: Workflow<ActionableItemType>) {
        store(in: &workflow.cancellableStore)
    }
}
