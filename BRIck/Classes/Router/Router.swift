//
//  Router.swift
//  BRIck
//
//  Created by Gorilka on 7/31/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

/// The base class of all routers that does not own view controllers, representing application states.
///
/// A router acts on inputs from its corresponding interactor, to manipulate application state, forming a tree of routers.
/// A router may obtain a view controller through constructor injection to manipulate view controller tree.
/// The DI structure guarantees that the injected view controller must be from one of this router's ancestors.
/// Router drives the lifecycle of its owned `Interactor`.
///
/// Routers should always use helper builders to instantiate children routers.
open class Router<InteractorType> {
    /// The corresponding `Interactor` owned by this `Router`.
    public let interactor: InteractorType

    /// The base `Interactable` associated whit this `Router`.
    public let interactable: Interactable

    /// The list of children `Router`s of this `Router`.
    public final var children: [Routing] = []

    fileprivate var didLoadFlag: Bool = false

    /// Initializer.
    ///
    /// - Parameter interactor: The corresponding `Interactor` of this `Router`.
    public init(interactor: InteractorType) {
        self.interactor = interactor
        guard let interactable = interactor as? Interactable else {
            fatalError("\(interactor) should conform to \(Interactable.self)")
        }

        self.interactable = interactable
    }

    deinit {
        interactable.deactivate()

        if !children.isEmpty {
            detachAllChildren()
        }
    }
}

extension Router {
    /// Loads the `Router`.
    ///
    /// - Note: This method is internally used by the framework. Application code should never invoke this method explicitly.
    public func load() {
        guard !didLoadFlag else { return }

        didLoadFlag = true
        internalDidLoad()
        didLoad()
    }

    private func internalDidLoad() {
        interactable.activityHandler = { [weak self] isActive in
            guard let strongSelf = self else { return }
            strongSelf.setSubtreeActive(isActive)
        }
    }

    private func setSubtreeActive(_ active: Bool) {
        switch active {
        case true:
            iterateSubtree(self) { router in
                if !router.interactable.isActive {
                    router.interactable.activate()
                }
            }
        case false:
            iterateSubtree(self) { router in
                if router.interactable.isActive {
                    router.interactable.deactivate()
                }
            }
        }
    }

    private func iterateSubtree(_ root: Routing, closure: (_ node: Routing) -> Swift.Void) {
        closure(root)

        root.children.forEach { iterateSubtree($0, closure: closure) }
    }

    private func detachAllChildren() {
        children.forEach { detach($0) }
    }
}
