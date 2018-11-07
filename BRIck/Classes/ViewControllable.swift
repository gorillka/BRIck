//
//  ViewControllable.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import UIKit

/// Basic interface between a `Router` and the UIKit `UIViewController`.
public protocol ViewControllable: class {
    var uiViewController: UIViewController { get }
    func show(_ controller: ViewControllable, embedInNavigationController: Bool)
    func show(_ controller: ViewControllable, insideView targetView: UIView)
}

/// Default implementation on `UIViewController` to conform to `ViewControllable` protocol.
public extension ViewControllable where Self: UIViewController {
    var uiViewController: UIViewController {
        return self
    }

    func show(_ controller: ViewControllable, embedInNavigationController: Bool = false) {
        let vc = embedInNavigationController ? self.embedInNavigationController() : controller.uiViewController
        show(vc, sender: nil)
    }

    func show(_ controller: ViewControllable, insideView targetView: UIView) {
        addChild(controller.uiViewController)
        targetView.addSubview(controller.uiViewController.view)

        stretchToBounds(holder: targetView, view: controller.uiViewController.view)
        controller.uiViewController.didMove(toParent: self)
    }
}

fileprivate extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        return getNavigationController() ?? UINavigationController(rootViewController: self)
    }

    func getNavigationController() -> UINavigationController? {
        var result: UINavigationController?
        if let navController = navigationController {
            result = navController
        } else if let parent = parent, let navController = parent.navigationController {
            result = navController
        }

        return result
    }

    func stretchToBounds(holder: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let pinDirections: [NSLayoutConstraint.Attribute] = [.top, .leading, .bottom, .trailing]
        let pinConstraints = pinDirections.map {
            NSLayoutConstraint(item: view, attribute: $0, relatedBy: .equal, toItem: holder, attribute: $0, multiplier: 1, constant: 0)
        }

        holder.addConstraints(pinConstraints)
    }
}
