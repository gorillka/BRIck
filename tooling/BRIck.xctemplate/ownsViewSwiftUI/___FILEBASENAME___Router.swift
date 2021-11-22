// ___FILEHEADER___

import BRIck
import BRIck_SwiftUI

protocol ___VARIABLE_productName___Interactable: Interactable {
    var router: ___VARIABLE_productName___Routing? { get set }
    var listener: ___VARIABLE_productName___Listener? { get set }
}

protocol ___VARIABLE_productName___ViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ___VARIABLE_productName___Router<ViewControllableType>: ViewableRouter<___VARIABLE_productName___Interactable, ViewControllableType, ___VARIABLE_productName___View> where ViewControllableType: ___VARIABLE_productName___ViewControllable {
    // MARK: Public Properties

    // MARK: Private Properties

    // MARK: Inits

    override init(
        interactor: ___VARIABLE_productName___Interactable,
        viewControllable: ViewControllableType,
        view: ___VARIABLE_productName___View
    ) {
        // TODO: Constructor inject child builder protocols to allow building children.
        
        super.init(interactor: interactor, viewControllable: viewControllable, view: view)
        
        interactor.router = self
    }

    // MARK: Override Methods

    // MARK: Public Methods

    // MARK: Private Methods
}

// MARK: - ___VARIABLE_productName___Routing

extension ___VARIABLE_productName___Router: ___VARIABLE_productName___Routing {}
