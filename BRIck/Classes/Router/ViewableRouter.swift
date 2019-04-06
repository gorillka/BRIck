//
//  ViewableRouter.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import UIKit

/// The base class of all routers that owns view controllers, representing applications states.
///
/// A `Router` acts on inputs from its corresponding interactors, representing application states.
open class ViewableRouter<InteractorType, ViewControllerType>: Router<InteractorType> {
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
}
