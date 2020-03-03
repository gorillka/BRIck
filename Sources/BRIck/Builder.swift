
/// The base builder protocol that all builders should conform to.
public protocol Buildable: AnyObject {}

/// Utility that instantiates a BRIck and sets up its internal dependencies.
open class Builder<DependencyType>: Buildable {

    /// The dependency used for this builder to build BRIck.
    public let dependency: DependencyType
    
    /// Initializer.
    ///
    /// - Parameter dependency: The dependency used for this builder to build the BRIck.
    public init(dependency: DependencyType) {
        self.dependency = dependency
    }
}
