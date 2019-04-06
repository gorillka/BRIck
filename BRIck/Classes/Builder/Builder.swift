//
//  Builder.swift
//  BRIck
//
//  Created by Gorilka on 7/31/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

/// Utility that instantiates a BRIck and sets up its internal dependencies.
open class Builder<DependencyType> {

    /// The dependency used for this builder to build BRIck.
    public let dependency: DependencyType
    
    /// initializer.
    ///
    /// - Parameter dependency: The dependency used for this builder to build the BRIck.
    public init(dependency: DependencyType) {
        self.dependency = dependency
    }
}
