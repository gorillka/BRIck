// ___FILEHEADER___

import BRIck

protocol ___VARIABLE_productName___Interactable: Interactable {
    var router: ___VARIABLE_productName___Routing? { get set }
    var listener: ___VARIABLE_productName___Listener? { get set }
}

final class ___VARIABLE_productName___Router: Router<___VARIABLE_productName___Interactable> {

    // TODO: Constructor inject child builder protocols to allow building children.
    
    override init(interactor: ___VARIABLE_productName___Interactable) {
        super.init(interactor: interactor)
        interactor.router = self
    }
}

extension ___VARIABLE_productName___Router: ___VARIABLE_productName___Routing {}
