//
//  Presenter.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

public protocol Presentable: class {}

open class Presenter<ViewControllerType: AnyObject>: Presentable {
    let viewController: ViewControllerType

    public required init(viewController: ViewControllerType) {
        self.viewController = viewController
    }
}
