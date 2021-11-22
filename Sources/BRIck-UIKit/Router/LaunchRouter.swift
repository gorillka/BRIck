//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import BRIck

/// The root `Router` of an application.
public protocol LaunchRouting: ViewableRouting {
    /// Launch the router tree.
    ///
    /// - Parameters:
    ///   - window: The application window to launch from.
    func launch(in window: Window)
}

/// The application root router base class, that acts as the root of the router tree.
open class LaunchRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>,
    LaunchRouting
{
    /// Launch the router tree.
    ///
    /// - Parameters:
    ///   - window: The application window to launch from.
    public func launch(in window: Window) {
        window.rootViewController = viewControllable
        window.makeKeyAndVisible()

        interactable.activate()
        load()
    }
}
