// ___FILEHEADER___

import BRIck
import Combine

protocol ___VARIABLE_productName___Dependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class ___VARIABLE_productName___Component: Component<___VARIABLE_productName___Dependency> {

    let rootViewController: ___VARIABLE_productName___ViewController

    init(dependency: ___VARIABLE_productName___Dependency, rootViewController: ___VARIABLE_productName___ViewController) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol ___VARIABLE_productName___Buildable: Buildable {
    func build() -> ___VARIABLE_productName___Routing
}

final class ___VARIABLE_productName___Builder: Builder<___VARIABLE_productName___Dependency> {

    // MARK: Public Properties
    
    // MARK: Private Properties
    
    // MARK: Inits
    
    override init(dependency: ___VARIABLE_productName___Dependency) {
        super.init(dependency: dependency)
    }
    
    // MARK: Override Methods
    
    // MARK: Public Methods
    
    // MARK: Private Methods
}

// MARK: - ___VARIABLE_productName___Buildable

extension ___VARIABLE_productName___Builder: ___VARIABLE_productName___Buildable {

    func build() -> ___VARIABLE_productName___Routing {
        let viewController = ___VARIABLE_productName___ViewController()
        let component = ___VARIABLE_productName___Component(dependency: dependency, rootViewController: viewController)
        let interactor = ___VARIABLE_productName___Interactor(presenter: viewController)

        return ___VARIABLE_productName___Router(interactor: interactor, viewController: viewController)
    }
}
