//
//  LaunchRouting.swift
//  BRIck
//
//  Created by Artem Orynko on 4/6/19.
//  Copyright © 2019 Gorilka. All rights reserved.
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

extension LaunchRouting {

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
