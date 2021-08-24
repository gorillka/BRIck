//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Foundation

/// The base class for all components.
///
/// A component defines private properties a BRIck provides to its internal `Router`, `Interactor`, `Presenter` and
/// view units, as well as public properties to its child BRIcks.
///
/// A component subclass implementation should conform to child `Dependency` protocols, defined by all of its immediate children.
open class Component<DependencyType>: Dependency {
    // MARK: - Public Properties

    /// The dependency of this `Component`.
    public let dependency: DependencyType

    // MARK: - Private Properties

    private var sharedInstances: [String: Any] = [:]
    private let lock = NSRecursiveLock()

    // MARK: - Inits

    /// Initialiser.
    ///
    /// - Parameter dependency: The dependency of this `Component`, usually provided by the parent `Component`.
    public init(dependency: DependencyType) {
        self.dependency = dependency
    }

    // MARK: - Public Methods

    /// Used to create a shared dependency in your `Component` sub-class. Shared dependencies are retained and reused by the component.
    /// Each dependent asking for this dependency will receive the same instance while the component is alive.
    ///
    /// - Note: Any shared dependency's constructor may not switch threads as this might cause a deadlock.
    ///
    /// - Parameters:
    ///   - factory: The closure to construct the dependency.
    /// - Returns: The instance.
    public final func shared<T>(__function: String = #function, _ factory: () -> T) -> T {
        lock.lock()
        defer {
            lock.unlock()
        }

        if let instance = (sharedInstances[__function] as? T?) ?? nil {
            return instance
        }

        let instance = factory()
        sharedInstances[__function] = instance

        return instance
    }
}

/// The special empty component.
open class EmptyComponent: EmptyDependency {
    // MARK: - Inits

    /// Initialiser.
    public init() {}
}
