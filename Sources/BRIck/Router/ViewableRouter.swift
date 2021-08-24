//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Combine

/// The base protocol for all routers that own their own view controllers.
public protocol ViewableRouting: Routing {
    /// The base view controllable associated with this `Router`.
    var viewControllable: ViewControllable { get }
}

/// The base class of all routers that owns view controllers, representing applications states.
///
/// A `Router` acts on inputs from its corresponding interactors, representing application states.
open class ViewableRouter<InteractorType, ViewControllerType>: Router<InteractorType>, ViewableRouting {
    private var viewControllerDisappearExpectation: LeakDetectionHandler?

    /// The corresponding `ViewController` owned by this `Router`.
    public let viewController: ViewControllerType

    /// The base `ViewControllable` associated with this `Router`.
    public let viewControllable: ViewControllable

    /// Initializer.
    ///
    /// - Parameters:
    ///   - interactor: The corresponding `Interactor` of this `Router`.
    ///   - viewController: The corresponding `ViewController` of this `Router`.
    public init(interactor: InteractorType, viewController: ViewControllerType) {
        guard let viewControllable = viewController as? ViewControllable else {
            fatalError("\(viewController) should conform to \(ViewControllable.self)")
        }

        self.viewController = viewController
        self.viewControllable = viewControllable

        super.init(interactor: interactor)
    }

    override func internalDidLoad() {
        setupViewControllerLeakDetection()

        super.internalDidLoad()
    }

    private func setupViewControllerLeakDetection() {
        interactable
            .isActiveStream
            .sink { [weak self] isActive in
                guard let self = self else { return }

                self.viewControllerDisappearExpectation?.cancel()
                self.viewControllerDisappearExpectation = nil

                if isActive { return }

                let viewController = self.viewControllable
                self.viewControllerDisappearExpectation = LeakDetector.shared
                    .expectViewControllerDisappear(viewController)
            }
            .store(in: &cancellable)
    }
}
