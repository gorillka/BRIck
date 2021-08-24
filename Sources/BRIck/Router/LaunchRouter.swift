//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import UIKit

/// The root `Router` of an application.
public protocol LaunchRouting: ViewableRouting {
    /// Launch the router tree.
    ///
    /// - Parameters:
    ///   - window: The application window to launch from.
    func launch(in window: UIWindow)
}

/// The application root router base class, that acts as the root of the router tree.
open class LaunchRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>,
    LaunchRouting
{
    /// Initializer.
    ///
    /// - Parameters:
    ///   - interactor: The corresponding `Interactor` of this `Router`.
    ///   - viewController: The corresponding `ViewController` of this `Router`.
    override public init(interactor: InteractorType, viewController: ViewControllerType) {
        super.init(interactor: interactor, viewController: viewController)
    }

    // Launch the router tree.
    ///
    /// - Parameters:
    ///   - window: The application window to launch from.
    public func launch(in window: UIWindow) {
        window.rootViewController = viewControllable
        window.makeKeyAndVisible()

        interactable.activate()
        load()
    }
}
