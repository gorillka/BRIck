// ___FILEHEADER___

import BRIck

protocol ___VARIABLE_productName___Dependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class ___VARIABLE_productName___Component: Component<___VARIABLE_productName___Dependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol ___VARIABLE_productName___Buildable: Buildable {
    func build(withListener: ___VARIABLE_productName___Listener) -> ___VARIABLE_productName___Routing
}

final class ___VARIABLE_productName___Builder: Builder<___VARIABLE_productName___Dependency> {

    override init(dependency: ___VARIABLE_productName___Dependency) {
        super.init(dependency: dependency)
    }
}

extension ___VARIABLE_productName___Builder: ___VARIABLE_productName___Buildable {

    func build(withListener listener: ___VARIABLE_productName___Listener) -> ___VARIABLE_productName___Routing {
        let component = ___VARIABLE_productName___Component(dependency: dependency)
        let interactor = ___VARIABLE_productName___Interactor()
        interactor.listener = listener

        return ___VARIABLE_productName___Router(interactor: interactor)
    }
}
