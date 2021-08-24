//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Combine

/// Protocol defining the activeness of an interactor's scope.
public protocol InteractorScope: AnyObject {
    typealias ActivityHandler = (Bool) -> Swift.Void

    /// The lifecycle handler of this interactor.
    var isActive: Bool { get }

    /// The lifecycle of this interactor.
    ///
    /// - note: Subscription to this stream always immediately returns the last event. This stream terminates after
    ///   the interactor is deallocated.
    var isActiveStream: AnyPublisher<Bool, Never> { get }
}

/// The base protocol for all interactors.
public protocol Interactable: InteractorScope {
    /// Activate this interactor.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application code should never explicitly invoke this method.
    func activate()

    /// Deactivate this interactor.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application code should never explicitly invoke this method.
    func deactivate()
}

/// An `Interactor` defines a unit of business logic that corresponds to a router unit.
///
/// An `Interactor` has a lifecycle driven by its owner router. When the corresponding router is attached to its parent,
/// its interactor becomes active. And when the router is detached from its parent, its `Interactor` resigns active.
///
/// An `Interactor` should only perform its business logic when it's currently active.
open class Interactor: Interactable {
    // MARK: - Public Properties

    /// Indicates if the interactor is active.
    public final var isActive: Bool { isActiveSubject.value }

    /// A stream notifying on the lifecycle of this interactor.
    public final var isActiveStream: AnyPublisher<Bool, Never> { isActiveSubject.eraseToAnyPublisher() }

    // MARK: - Private Properties

    private let isActiveSubject = CurrentValueSubject<Bool, Never>(false)
    fileprivate var cancellable = Set<AnyCancellable>()

    // MARK: - Inits

    public init() {}

    deinit {
        if isActive {
            deactivate()
        }

        isActiveSubject.send(completion: .finished)
    }

    // MARK: - Open Methods

    /// The `Interactor` did become active.
    ///
    /// - Note: This method is driven by the attachment of this interactor's owner router.
    /// Subclasses should override this method to setup initial state.
    open func didBecomeActive() {}

    /// Called when the `Interactor` will resign the active sate.
    ///
    /// This method is driven by the detachment of this `Interactors`'s owner router.
    /// Subclasses should override this method to cleanup any resources and states of the `Interactor`.
    /// The default implementation does nothing.
    open func willResignActive() {}

    // MARK: - Public Methods

    /// Activate the `Interactor`.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application code should never explicitly invoke this method.
    public func activate() {
        if isActive { return }

        cancellable = []

        isActiveSubject.send(true)

        didBecomeActive()
    }

    /// Deactivate this `Interactor`.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application should never explicitly invoke this method.
    public func deactivate() {
        guard isActive else { return }

        willResignActive()

        cancellable = []

        isActiveSubject.send(false)
    }
}

public extension Publisher where Failure == Never {
    func confine(to interactorScope: InteractorScope) -> AnyPublisher<Output, Never> {
        combineLatest(interactorScope.isActiveStream)
            .filter { _, isActive in isActive }
            .map { value, _ in value }
            .eraseToAnyPublisher()
    }
}

public extension Cancellable {
    @discardableResult
    func cancelOnDeactivate(_ interactor: Interactor) -> Cancellable {
        if interactor.cancellable.isEmpty {
            cancel()
        } else {
            store(in: &interactor.cancellable)
        }

        return self
    }
}
