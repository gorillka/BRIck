//
//  ViewableRouter.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import UIKit

/// The base protocol for all routers that own their own view controllers.
public protocol ViewableRouting: Routing {
    /// The base view controllable associated with this `Router`.
    var viewControllable: ViewControllable { get }
}

/// The base class of all routers that owns view controllers, representing applications states.
///
/// A `Router` acts on inputs from its corresponding interactors, representing application states.
open class ViewableRouter<InteractorType, ViewControllerType>: Router<InteractorType>, ViewableRouting {

    /// The corresponding `ViewController` owned by this `Router`.
    public let viewController: ViewControllerType

    /// The base `ViewControllable` associated with this `Router`.
    public let viewControllable: ViewControllable

    /// Initializer.
    ///
    /// - Parameters:
    ///   - interactor: The corresponding `Interactor` of this `Router`.
    ///   - viewController: The corresponding `ViewController` of this `Router`.
    public init(interactor: InteractorType, viewController: ViewControllerType) {
        guard let viewControllable = viewController as? ViewControllable else {
            fatalError("\(viewController) should conform to \(ViewControllable.self)")
        }

        self.viewController = viewController
        self.viewControllable = viewControllable

        super.init(interactor: interactor)
    }

    fileprivate var targetViewController: ViewControllable?
    fileprivate var animationInProgress = false
}

extension ViewableRouter where ViewControllerType: ViewControllable & UIViewController {
    public func show(_ router: ViewableRouter, embedInNavigationController: Bool = false) {
        let vc: UIViewController
        if embedInNavigationController {
            vc = router.viewController.embedInNavigationController()
        } else {
            vc = router.viewController.uiViewController
        }

        viewControllable.uiViewController.show(vc, sender: nil)
    }
}
