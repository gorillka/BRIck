// ___FILEHEADER___

import UIKit
import BRIck

protocol ___VARIABLE_productName___PresentableListener: class {

    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class ___VARIABLE_productName___ViewController: UIViewController {

    weak var listener: ___VARIABLE_productName___PresentableListener?
}

extension ___VARIABLE_productName___ViewController: ___VARIABLE_productName___Presentable {}

extension ___VARIABLE_productName___ViewController: ___VARIABLE_productName___ViewControllable {}
