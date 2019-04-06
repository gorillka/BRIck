//
//  Presenter.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

/// The base class of all `Presenter`'s. A `Presenter` translates business models into values the corresponding `ViewController` can consume and display.
/// It also maps UI events to business logic method, invoke to its listener.
open class Presenter<ViewControllerType: AnyObject> {
    /// The `ViewController` of this `Presenter`.
    let viewController: ViewControllerType

    /// Initializer.
    ///
    /// - Parameter viewController: The `ViewController` of this `Presenter`.
    public required init(viewController: ViewControllerType) {
        self.viewController = viewController
    }
}
