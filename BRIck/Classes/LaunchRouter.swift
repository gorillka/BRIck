//
//  LaunchRouter.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
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
open class LaunchRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>, LaunchRouting {

    /// Initializer.
    ///
    /// - Parameters:
    ///   - interactor: The corresponding `Interactor` of this `Router`.
    ///   - viewController: The corresponding `ViewController` of this `Router`.
    public override init(interactor: InteractorType, viewController: ViewControllerType) {
        super.init(interactor: interactor, viewController: viewController)
    }

    // Launch the router tree.
    ///
    /// - Parameters:
    ///   - window: The application window to launch from.
    public func launch(in window: UIWindow) {
        let view = viewControllable.uiViewController

        window.rootViewController = view
        window.makeKeyAndVisible()

        interactable.activate()
        load()
    }
}
