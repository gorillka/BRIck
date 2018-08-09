//
//  Presenter.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

/// The base protocol for all `Presenter`'s.
public protocol Presentable: class {}

/// The base class of all `Presenter`'s. A `Presenter` translates business models into values the corresponding `ViewController` can consume and display.
/// It also maps UI events to business logic method, invoke to its listener.
open class Presenter<ViewControllerType: AnyObject>: Presentable {

    /// The `ViewController` of this `Presenter`.
    let viewController: ViewControllerType

    /// Initializer.
    ///
    /// - Parameter viewController: The `ViewController` of this `Presenter`.
    public required init(viewController: ViewControllerType) {
        self.viewController = viewController
    }
}
