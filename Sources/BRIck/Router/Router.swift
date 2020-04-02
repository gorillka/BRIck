
/// The base protocol for all routers.
public protocol Routing: AnyObject {
	/// The base interactable associated with this `Router`.
	var interactable: Interactable { get }

	/// The list of children routers of this `Router`.
	var children: [Routing] { get }

	/// Loads the `Router`.
	///
	/// - Note: This method is internally used by framework. Application code should never invoke this method explicitly.
	func load()

	/// Attaches the given router as child.
	///
	/// - Parameter child: The child router to attach.
	func attach(_ child: Routing)

	/// Detaches the given router from the tree.
	///
	/// - Parameter child: The child router to detach.
	func detach(_ child: Routing)
}

/// The base class of all routers that does not own view controllers, representing application states.
///
/// A router acts on inputs from its corresponding interactor, to manipulate application state, forming a tree of routers.
/// A router may obtain a view controller through constructor injection to manipulate view controller tree.
/// The DI structure guarantees that the injected view controller must be from one of this router's ancestors.
/// Router drives the lifecycle of its owned `Interactor`.
///
/// Routers should always use helper builders to instantiate children routers.
open class Router<InteractorType>: Routing {
	/// The corresponding `Interactor` owned by this `Router`.
	public let interactor: InteractorType

	/// The base `Interactable` associated whit this `Router`.
	public let interactable: Interactable

	/// The list of children `Router`s of this `Router`.
	public final var children: [Routing] = []

	@usableFromInline
	internal var didLoadFlag: Bool = false

	/// Initializer.
	///
	/// - Parameter interactor: The corresponding `Interactor` of this `Router`.
	public init(interactor: InteractorType) {
		self.interactor = interactor
		guard let interactable = interactor as? Interactable else {
			fatalError("\(interactor) should conform to \(Interactable.self)")
		}

		self.interactable = interactable
	}

	deinit {
		interactable.deactivate()

		children.forEach(detach(_:))
	}

	/// Loads the `Router`.
	///
	/// - Note: This method is internally used by the framework. Application code should never invoke this method explicitly.
	@inline(__always)
	@inlinable
	public final func load() {
		guard !didLoadFlag else {
			return
		}

		didLoadFlag = true
		internalDidLoad()
		didLoad()
	}

	/// Attaches the given router as child.
	///
	/// - Parameter child: The child router to attach.
	@inline(__always)
	@inlinable
	public final func attach(_ child: Routing) {
		assert(!(children.contains { $0 === child }),
		       "Attempt to attach child: \(child), which is already attached to \(self).")

		children.append(child)

		child.interactable.activate()
		child.load()
	}

	/// Detaches the given router from the tree.
	///
	/// - Parameter child: The child router to detach.
	@inline(__always)
	@inlinable
	public final func detach(_ child: Routing) {
		child.interactable.deactivate()

		children.removeElementByReference(child)
	}

	/// Called when the router has finished loading.
	///
	/// This method is invoke only once. Subclasses should override this method to perform one time setup logic,
	/// such as attaching immutable children. The default implementation does nothing.
	@inline(__always)
	@inlinable
	open func didLoad() {}

	// MARK: - Internal Methods

	@usableFromInline
	internal final func internalDidLoad() {
		interactable.activityHandler = { [weak self] isActive in
			guard let strongSelf = self else { return }
			strongSelf.setSubtreeActive(isActive)
		}
	}

	// MARK: - Private Methods

	private func setSubtreeActive(_ active: Bool) {
		switch active {
		case true:
			iterateSubtree(self) { router in router.interactable.activate() }
		case false:
			iterateSubtree(self) { router in router.interactable.deactivate() }
		}
	}

	private func iterateSubtree(_ root: Routing, closure: (_ node: Routing) -> Swift.Void) {
		closure(root)

		root.children.forEach { iterateSubtree($0, closure: closure) }
	}
}
