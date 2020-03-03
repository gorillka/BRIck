
/// Base class of an `Interactor` that actually has an associated `Presenter` and `View`.
open class PresentableInteractor<PresenterType>: Interactor {
    /// The `Presenter` associated with this `Interactor`.
    public let presenter: PresenterType

    /// Initializer.
    ///
    /// - Note: This holds a strong reference to the given `Presenter`.
    ///
    /// - Parameter presenter: The `Presenter` associated with this `Interactor`.
    public init(presenter: PresenterType) {
        self.presenter = presenter
    }
}
