//
//  LaunchRouter.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import UIKit

public protocol LaunchRouting: ViewableRouting {
    func launch(in window: UIWindow, embedInNavigationController: Bool)
}


open class LauchRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>, LaunchRouting {

    public override init(interactor: InteractorType, viewController: ViewControllerType) {
        super.init(interactor: interactor, viewController: viewController)
    }

    public func launch(in window: UIWindow, embedInNavigationController: Bool) {
        let view: UIViewController

        if embedInNavigationController {
            view = self.embedInNavigationController()
        } else {
            view = viewControllable.uiViewController
        }

        window.rootViewController = view
        window.makeKeyAndVisible()

        interactable.activate()
        load()
    }
}
