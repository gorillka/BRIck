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
}

/// Default implementation on `UIViewController` to conform to `ViewControllable` protocol.
public extension ViewControllable where Self: UIViewController {
    var uiViewController: UIViewController {
        return self
    }
}

extension ViewControllable where Self: UIViewController {
    fileprivate var navigationController: UINavigationController? {
        var result: UINavigationController?

        if let navigationController = uiViewController.navigationController {
            result = navigationController
        } else if let parent = uiViewController.parent,
            let navigationController = parent.navigationController {
            result = navigationController
        }

        return result
    }

    func embedInNavigationController() -> UINavigationController {
        return navigationController ?? UINavigationController(rootViewController: uiViewController)
    }
}
