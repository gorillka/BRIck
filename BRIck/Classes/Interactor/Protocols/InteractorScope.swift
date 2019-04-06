//
//  InteractorScope.swift
//  BRIck
//
//  Created by Artem Orynko on 4/6/19.
//  Copyright © 2019 Gorilka. All rights reserved.
//

/// Protocol defining the activeness of an interactor's scope.
public protocol InteractorScope: class {
    typealias ActivityHandler = (Bool) -> Swift.Void

    /// The lifecycle handler of this interactor.
    var isActive: Bool { get }

    /// A handler notifying on the lifecycle of this interactor.
    var activityHandler: ActivityHandler? { get set }
}
