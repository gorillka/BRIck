//
//  Routing.swift
//  BRIck
//
//  Created by Artem Orynko on 4/6/19.
//  Copyright © 2019 Gorilka. All rights reserved.
//

/// The base protocol for all routers.
public protocol Routing: class {
    /// The base interactable associated with this `Router`.
    var interactable: Interactable { get }

    /// The list of children routers of this `Router`.
    var children: [Routing] { get set }

    /// Loads the `Router`.
    ///
    /// - Note: This method is internally used by framework. Application code should never invoke this method explicitly.
    func load()

    /// Attaches the given router as child.
    ///
    /// - Parameter child: The child router to attach.
    func attach(_ child: Routing)

    /// Detaches the given router from the tree.
    ///
    /// - Parameter child: The child router to detach.
    func detach(_ child: Routing)
}

extension Routing {
    /// Called when the router has finished loading.
    ///
    /// This method is invoke only once. Subclasses should override this method to perform one time setup logic,
    /// such as attaching immutable children. The default implementation does nothing.
    public func didLoad() {}

    /// Attaches the given router as child.
    ///
    /// - Parameter child: The child router to attach.
    public func attach(_ child: Routing) {
        assert(!(children.contains { $0 === child }), "Attempt to attach child: \(child), wich is already attached to \(self).")

        children.append(child)

        child.interactable.activate()
        child.load()
    }

    /// Detaches the given router from the tree.
    ///
    /// - Parameter child: The child router to detach.
    public func detach(_ child: Routing) {
        child.interactable.deactivate()

        children.removeElementByReference(child)
    }
}
