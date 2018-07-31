//
//  Component.swift
//  BRIck
//
//  Created by Gorilka on 7/31/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

open class Component<DependencyType>: Dependency {
    public let dependency: DependencyType

    private var sharedInstances: [String: Any] = [:]
    private let lock: NSRecursiveLock = NSRecursiveLock()

    init(dependency: DependencyType) {
        self.dependency = dependency
    }

    public final func shared<T>(__function: String = #function, _ factory: () -> T) -> T {
        lock.lock()
        defer {
            lock.unlock()
        }

        if let instance = sharedInstances[__function] as? T {
            return instance
        }

        let instance = factory()
        sharedInstances[__function] = instance

        return instance
    }
}

open class EmptyComponent: EmptyDependency {
    public init() {}
}
