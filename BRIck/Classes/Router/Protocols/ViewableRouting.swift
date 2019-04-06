//
//  ViewableRouting.swift
//  BRIck
//
//  Created by Artem Orynko on 4/6/19.
//  Copyright © 2019 Gorilka. All rights reserved.
//

/// The base protocol for all routers that own their own view controllers.
public protocol ViewableRouting: Routing {
    /// The base view controllable associated with this `Router`.
    var viewControllable: ViewControllable { get }
}
