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
    func show(_ viewController: ViewControllable, embedInNavigationController: Bool)
}

/// Default implementation on `UIViewController` to conform to `ViewControllable` protocol.
public extension ViewControllable where Self: UIViewController {
    var uiViewController: UIViewController {
        return self
    }
    func show(_ viewController: ViewControllable, embedInNavigationController: Bool = false) {
        let vc: UIViewController
        if embedInNavigationController {
            vc = viewController.uiViewController.embedInNavigationController()
        } else {
            vc = viewController.uiViewController
        }

        uiViewController.show(vc, sender: nil)
    }
}

extension UIViewController {
    fileprivate var navController: UINavigationController? {
        var result: UINavigationController?

        if let navigationController = navigationController {
            result = navigationController
        } else if let parent = parent,
            let navigationController = parent.navigationController {
            result = navigationController
        }

        return result
    }

    func embedInNavigationController() -> UINavigationController {
        return navController ?? UINavigationController(rootViewController: self)
    }
}
