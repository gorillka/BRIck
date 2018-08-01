//
//  Router.swift
//  BRIck
//
//  Created by Gorilka on 7/31/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

public protocol Routing: class {
    var interactable: Interactable { get }
    var children: [Routing] { get }

    func load()
    func attach(_ child: Routing)
    func detach(_ child: Routing)
}

open class Router<InteractorType>: Routing {
    public let interactor: InteractorType
    public let interactable: Interactable
    public final var children: [Routing] = []

    private var didLoadFlag: Bool = false

    public init(interactor: InteractorType) {
        self.interactor = interactor
        guard let interactable = interactor as? Interactable else {
            fatalError("\(interactor) should conform to \(Interactable.self)")
        }

        self.interactable = interactable
    }

    public final func load() {
        guard !didLoadFlag else {
            return
        }

        didLoadFlag = true
        internalDidLoad()
        didLoad()
    }

    open func didLoad() {}

    public final func attach(_ child: Routing) {
        assert(!(children.contains { $0 === child }), "Attempt to attach child: \(child), wich is already attached to \(self).")

        children.append(child)

        child.interactable.activate()
        child.load()
    }

    public final func detach(_ child: Routing) {
        child.interactable.deactivate()

        children.removeByReference(child)
    }

    deinit {
        interactable.deactivate()

        if !children.isEmpty {
            detachAllChildren()
        }
    }

    internal func internalDidLoad() {
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
