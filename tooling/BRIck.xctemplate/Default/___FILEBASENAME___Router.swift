// ___FILEHEADER___

import BRIck
import Combine

protocol ___VARIABLE_productName___Interactable: Interactable {
    var router: ___VARIABLE_productName___Routing? { get set }
    var listener: ___VARIABLE_productName___Listener? { get set }
}

// MARK: - Router

final class ___VARIABLE_productName___Router: Router<___VARIABLE_productName___Interactable> {

    // MARK: Private Properties
    
    // MARK: Public Properties
    
    // MARK: Inits
    
    override init(interactor: ___VARIABLE_productName___Interactable) {
        // TODO: Constructor inject child builder protocols to allow building children.
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    // MARK: Override Methods
    
    // MARK: Public Methods
    
    // MARK: Private Methods
}

// MARK: - ___VARIABLE_productName___Routing

extension ___VARIABLE_productName___Router: ___VARIABLE_productName___Routing {}
