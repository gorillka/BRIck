//
//  ViewableRouter.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import UIKit

public protocol ViewableRouting: Routing {
    func show(from: UIViewController, embedInNavigationController: Bool)
    func show(from container: UIViewController, inside targetView: UIView)
}

open class ViewableRouter<InteractorType, ViewControllerType>: Router<InteractorType>, ViewableRouting {
    public let viewController: ViewControllerType
    public let viewControllable: ViewControllable

    public init(interactor: InteractorType, viewController: ViewControllerType) {
        guard let viewControllable = viewController as? ViewControllable else {
            fatalError("\(viewController) should conform to \(ViewControllable.self)")
        }

        self.viewController = viewController
        self.viewControllable = viewControllable

        super.init(interactor: interactor)
    }
}

public extension ViewableRouter {

    func show(from: UIViewController, embedInNavigationController: Bool = false) {
        let view: UIViewController

        if embedInNavigationController {
            view = self.embedInNavigationController()
        } else {
            view = viewControllable.uiViewController
        }

        from.show(view, sender: nil)

        interactable.activate()
        load()
    }

    func show(from container: UIViewController, inside targetView: UIView) {

        container.addChild(viewControllable.uiViewController)
        targetView.addSubview(viewControllable.uiViewController.view)

        stretchToBounds(holder: targetView, view: viewControllable.uiViewController.view)
        viewControllable.uiViewController.didMove(toParent: container)

        interactable.activate()
        load()
    }

    fileprivate func stretchToBounds(holder: UIView, view: UIView) {

        viewControllable.uiViewController.view.translatesAutoresizingMaskIntoConstraints = false

        let pinDirections: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        let pinConstraints = pinDirections.map { direction -> NSLayoutConstraint in
            return NSLayoutConstraint(item: view, attribute: direction, relatedBy: .equal, toItem: holder, attribute: direction, multiplier: 1, constant: 0)
        }

        holder.addConstraints(pinConstraints)
    }
}

internal extension ViewableRouter {

    fileprivate var navigationController: UINavigationController? {
        var result: UINavigationController?

        if let navigationController = viewControllable.uiViewController.navigationController {
            result = navigationController
        } else if let parent = viewControllable.uiViewController.parent, let navigationController = parent.navigationController {
            result = navigationController
        }

        return result
    }

    internal func embedInNavigationController() -> UINavigationController {
        let result: UINavigationController

        if let navigationController = navigationController {
            result = navigationController
        } else {
            result = UINavigationController(rootViewController: viewControllable.uiViewController)
        }

        return result
    }
}
