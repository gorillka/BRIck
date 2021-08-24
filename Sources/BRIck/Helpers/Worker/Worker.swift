//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Combine

/// The base protocol of all workers that perform a self-contained piece of logic.
///
/// `Worker`s are always bound to an `Interactor`. A `Worker` can only start if its bound `Interactor` is active.
/// It is stopped when its bound interactor is deactivated.
public protocol Working: AnyObject {
    /// Indicates if the worker is currently started.
    var isStarted: Bool { get }

    /// The lifecycle of this worker.
    ///
    /// Subscription to this stream always immediately returns the last event. This stream terminates after the
    /// `Worker` is deallocated.
    var isStartedStream: AnyPublisher<Bool, Never> { get }

    /// Starts the `Worker`.
    ///
    /// If the bound `InteractorScope` is active, this method starts the `Worker` immediately. Otherwise the `Worker`
    /// will start when its bound `Interactor` scope becomes active.
    ///
    /// - parameter interactorScope: The interactor scope this worker is bound to.
    func start(_ interactorScope: InteractorScope)

    /// Stops the worker.
    ///
    /// Unlike `start`, this method always stops the worker immediately.
    func stop()
}

/// The base `Worker` implementation.
open class Worker: Working {
    /// Indicates if the `Worker` is started.
    public final var isStarted: Bool { isStartedSubject.value }

    public final var isStartedStream: AnyPublisher<Bool, Never> {
        isStartedSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let isStartedSubject = CurrentValueSubject<Bool, Never>(false)
    private var cancellable: Cancellable?

    // MARK: - Fileprivate Properties

    fileprivate var store: Set<AnyCancellable>?

    // MARK: - Inits

    public init() {}

    deinit {
        stop()
        unbindingInteractor()
        isStartedSubject.send(completion: .finished)
    }

    // MARK: - Open Methods

    /// Called when the the worker has started.
    ///
    /// Subclasses should override this method and implment any logic that they would want to execute when the `Worker`
    /// starts. The default implementation does nothing.
    ///
    /// - parameter interactorScope: The interactor scope this `Worker` is bound to.
    open func didStart(_ interactorScope: InteractorScope) {}

    /// Called when the worker has stopped.
    ///
    /// Subclasses should override this method abnd implement any cleanup logic that they might want to execute when
    /// the `Worker` stops. The default implementation does noting.
    ///
    /// - note: All subscriptions added to the disposable provided in the `didStart` method are automatically disposed
    /// when the worker stops.
    open func didStop() {}

    // MARK: - Public Properties

    /// Starts the `Worker`.
    ///
    /// If the bound `InteractorScope` is active, this method starts the `Worker` immediately. Otherwise the `Worker`
    /// will start when its bound `Interactor` scope becomes active.
    ///
    /// - parameter interactorScope: The interactor scope this worker is bound to.
    public final func start(_ interactorScope: InteractorScope) {
        if isStarted { return }

        stop()
        isStartedSubject.send(true)

        // Create a separate scope struct to avoid passing the given scope instance, since usually
        // the given instance is the interactor itself. If the interactor holds onto the worker without
        // de-referencing it when it becomes inactive, there will be a retain cycle.
        let weakInteractorScope = WeakInteractorScope(interactorScope)
        bind(to: weakInteractorScope)
    }

    /// Stops the worker.
    ///
    /// Unlike `start`, this method always stops the worker immediately.
    public final func stop() {
        guard isStarted else { return }

        isStartedSubject.send(false)

        executeStop()
    }

    // MARK: - Private Methods

    private final func bind(to interactorScope: InteractorScope) {
        unbindingInteractor()

        cancellable = interactorScope
            .isActiveStream
            .sink(receiveValue: { [weak self] isActive in
                if isActive {
                    if self?.isStarted == true {
                        self?.executeStart(interactorScope)
                    }
                } else {
                    self?.executeStop()
                }
            })
    }

    private final func executeStart(_ interactorScope: InteractorScope) {
        store = []
        didStart(interactorScope)
    }

    private final func executeStop() {
        guard let _ = store else { return }

        self.store = []
        self.store = nil

        didStop()
    }

    private final func unbindingInteractor() {
        cancellable?.cancel()
        cancellable = nil
    }
}

private final class WeakInteractorScope: InteractorScope {
    weak var sourceScope: InteractorScope?

    var isActive: Bool { sourceScope?.isActive ?? false }
    var isActiveStream: AnyPublisher<Bool, Never> {
        sourceScope?.isActiveStream ?? Just(false).eraseToAnyPublisher()
    }

    fileprivate init(_ source: InteractorScope) {
        self.sourceScope = source
    }
}

public extension Cancellable {
    @discardableResult
    func cancelOnStop(_ worker: Worker) -> Cancellable {
        if let _ = worker.store {
            store(in: &worker.store!)
        } else {
            cancel()
        }

        return self
    }
}
