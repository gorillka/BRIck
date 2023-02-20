// ___FILEHEADER___

import BRIck
import BRIck_SwiftUI
import Combine

protocol ___VARIABLE_productName___PresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
    func onAppear()
    func onDisappear()
}

final class ___VARIABLE_productName___Presenter {
    // MARK: Public Properties

    weak var listener: ___VARIABLE_productName___PresentableListener?

    // MARK: Private Properties

    // MARK: Inits

    // MARK: Override Methods

    // MARK: Public Methods

    // MARK: Private Methods
}

// MARK: - ___VARIABLE_productName___ViewControllable

extension ___VARIABLE_productName___Presenter: ___VARIABLE_productName___ViewControllable {}

// MARK: - ___VARIABLE_productName___Presentable

extension ___VARIABLE_productName___Presenter: ___VARIABLE_productName___Presentable {}
