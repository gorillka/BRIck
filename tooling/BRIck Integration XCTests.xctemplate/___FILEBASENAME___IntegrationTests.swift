// ___FILEHEADER___

@testable import ___PROJECTNAME___
import SwiftUI
import XCTest

final class ___VARIABLE_productName___IntegrationTests: XCTest {
    // MARK: Private properties

    private var interactor: ___VARIABLE_productName___Interactor!
    private var presenter: ___VARIABLE_productName___Presenter!
    private var router: ___VARIABLE_productName___Router<___VARIABLE_productName___Presenter, EmptyView>!

    // TODO: declare other objects and mocks you need as provate vars

    // MARK: Lifecycle

    override func setUp()  {
        super.setUp()

        let presenter = ___VARIABLE_productName___Presenter()
        let view = EmptyView()
        let interactor = ___VARIABLE_productName___Interactor(presenter: presenter)

        let router = ___VARIABLE_productName___Router(
            interactor: interactor,
            viewControllable: presenter,
            view: view
        )

        self.interactor = interactor
        self.presenter = presenter
        self.router = router
    }

    override func tearDown()  {
        super.tearDown()

        interactor = nil
        presenter = nil
        router = nil
    }

    // MARK: - Tests
}
