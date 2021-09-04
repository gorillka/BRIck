// ___FILEHEADER___

import BRIck
import Combine

protocol ___VARIABLE_productName___Routing: ViewableRouting {

    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ___VARIABLE_productName___Presentable: Presentable {
    var listener: ___VARIABLE_productName___PresentableListener? { get set }

    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ___VARIABLE_productName___Listener: class {

    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class ___VARIABLE_productName___Interactor: PresentableInteractor<___VARIABLE_productName___Presentable> {
    
    // MARK: Public Properties

    weak var router: ___VARIABLE_productName___Routing?
    weak var listener: ___VARIABLE_productName___Listener?
    
    // MARK: Private Properties

    // MARK: Inits

    override init(presenter: ___VARIABLE_productName___Presentable) {
        // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.
        super.init(presenter: presenter)
        presenter.listener = self
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

// MARK: - ___VARIABLE_productName___PresentableListener

extension ___VARIABLE_productName___Interactor: ___VARIABLE_productName___PresentableListener {}
