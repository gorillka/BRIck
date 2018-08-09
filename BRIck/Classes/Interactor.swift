//
//  Interactor.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

/// Protocol defining the activeness of an interactor's scope.
public protocol InteractorScope: class {
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

    /// Deactivate this router.
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
    public var activityHandler: ActivityHandler?

    /// The lifecycle handler of this interactor.
    public private(set) var isActive: Bool = false {
        didSet {
            activityHandler?(isActive)
        }
    }

    /// Initializer.
    public init() {
        // Mo-op
    }

    /// The `Interactor` did become active.
    ///
    /// - Note: This method is driven by the attachment of this interactor's owner router.
    /// Subclasses should override this method to setup initial state.
    open func didBecomeActive() {
        // No-op
    }

    /// Called when the `Interactor` will resign the active sate.
    ///
    /// This method is driven by the detachment of this `Interactors`'s owner router.
    /// Subclasses should override this method to cleanup any resources and states of the `Interactor`.
    /// The default implementation does nothing.
    open func willResignActive() {
        // No-op
    }

    /// Activate the `Interactor`.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application code should never explicitly invoke this method.
    public func activate() {
        guard !isActive else {
            return
        }

        isActive = true

        didBecomeActive()
    }

    /// Deactivate this `Interactor`.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application should never explicitly invoke this method.
    public func deactivate() {
        guard isActive else {
            return
        }

        willResignActive()

        isActive = false
    }

    deinit {
        if isActive {
            deactivate()
        }

        activityHandler = nil
    }
}
