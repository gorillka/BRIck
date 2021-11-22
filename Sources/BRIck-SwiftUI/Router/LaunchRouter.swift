//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import BRIck
import SwiftUI

/// The root `Router` of an application.
public protocol LaunchRouting: ViewableRouting {
    /// Launch the router tree.
    ///
    /// - Parameters:
    ///   - window: The application window to launch from.
    func launch(in window: Window)
}

/// The application root router base class, that acts as the root of the router tree.
open class LaunchRouter<InteractorType, ViewControllableType, Content>:
    ViewableRouter<InteractorType, ViewControllableType, Content>, LaunchRouting
    where ViewControllableType: ViewControllable, Content: View
{
    // MARK: Public Properties

    public let rootRouter: ViewRouter

    // MARK: Private Properties

    private let rootView: RootView

    // MARK: Inits

    /// Initializer.
    ///
    /// - Parameters:
    ///   - interactor: The corresponding `Interactor` of this `Router`.
    ///   - viewControllable: The corresponding `ViewControllable` of this `Router`.
    override public init(
        interactor: InteractorType,
        viewControllable: ViewControllableType,
        view: Content
    ) {
        let router = ViewRouter()
        self.rootRouter = router
        self.rootView = RootView(router) { view }

        super.init(interactor: interactor, viewControllable: viewControllable, view: view)
    }

    /// Launch the router tree.
    ///
    /// - Parameters:
    ///   - window: The application window to launch from.
    public func launch(in window: Window) {
        window.rootViewController = HostingController(rootView: rootView)
        window.makeKeyAndVisible()

        interactable.activate()
        load()
    }
}
