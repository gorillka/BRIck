//
//  Builder.swift
//  BRIck
//
//  Created by Gorilka on 7/31/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

public protocol Buildable: class {}

open class Builder<DependencyType>: Buildable {
    public let dependency: DependencyType

    public init(dependency: DependencyType) {
        self.dependency = dependency
    }
}
