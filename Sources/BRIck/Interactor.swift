
/// Protocol defining the activeness of an interactor's scope.
public protocol InteractorScope: AnyObject {
    typealias ActivityHandler = (Bool) -> Swift.Void

    /// The lifecycle handler of this interactor.
    var isActive: Bool { get }

    /// A handler notifying on the lifecycle of this interactor.
    var activityHandler: ActivityHandler? { get set }
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
    /// A handler notifying on the lifecycle of this interactor.
    public final var activityHandler: ActivityHandler?

    /// The lifecycle handler of this interactor.
    @inline(__always)
    @inlinable
    public final var isActive: Bool { _isActive }
    
    @usableFromInline
    internal var _isActive: Bool = false {
        didSet { activityHandler?(_isActive) }
    }

    /// Initializer.
    public init() {}

    deinit {
        if isActive {
            deactivate()
        }

        activityHandler = nil
    }
    
    /// Activate the `Interactor`.
     ///
     /// - Note: This method is internally invoked by the corresponding router. Application code should never explicitly invoke this method.
    @inline(__always)
    @inlinable
     public func activate() {
         if isActive { return }

         _isActive = true

         didBecomeActive()
     }

     /// Deactivate this `Interactor`.
     ///
     /// - Note: This method is internally invoked by the corresponding router. Application should never explicitly invoke this method.
    @inline(__always)
    @inlinable
     public func deactivate() {
         guard isActive else { return }

         willResignActive()

         _isActive = false
     }
    
    /// The `Interactor` did become active.
    ///
    /// - Note: This method is driven by the attachment of this interactor's owner router.
    /// Subclasses should override this method to setup initial state.
    @inline(__always)
    @inlinable
    open func didBecomeActive() {}

    /// Called when the `Interactor` will resign the active sate.
    ///
    /// This method is driven by the detachment of this `Interactors`'s owner router.
    /// Subclasses should override this method to cleanup any resources and states of the `Interactor`.
    /// The default implementation does nothing.
    @inline(__always)
    @inlinable
    open func willResignActive() {}
}
