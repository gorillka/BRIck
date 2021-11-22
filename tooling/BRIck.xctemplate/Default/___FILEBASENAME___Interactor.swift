// ___FILEHEADER___

import BRIck
import Combine

protocol ___VARIABLE_productName___Routing: Routing {
    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ___VARIABLE_productName___Listener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

// MARK: - Interactor

final class ___VARIABLE_productName___Interactor: Interactor {
    // MARK: Public Properties

    weak var router: ___VARIABLE_productName___Routing?
    weak var listener: ___VARIABLE_productName___Listener?

    // MARK: Private Properties

    // MARK: Inits

    override init() {
        // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.
    }

    // MARK: Override Methods

    override func didBecomeActive() {
        super.didBecomeActive()

        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()

        // TODO: Pause any business logic.
    }

    // MARK: Public Methods

    // MARK: Private Methods
}

// MARK: - ___VARIABLE_productName___Interactable

extension ___VARIABLE_productName___Interactor: ___VARIABLE_productName___Interactable {}
