@testable import BRIck
import Combine
import XCTest

final class LaunchRouterTests: XCTestCase {
    
    private var launchRouter: LaunchRouting!
    
    private var interactor: InteractableMock!
    private var viewController: ViewControllable!
    
    override func setUp() {
        super.setUp()
        
        interactor = InteractableMock()
        viewController = ViewControllerMock(nibName: nil, bundle: nil)
        launchRouter = LaunchRouter(interactor: interactor, viewController: viewController)
    }
    
    func test_launchFromWindow() {
        let window = WindowMock(frame: .zero)
        launchRouter.launch(in: window)
        
        XCTAssert(window.rootViewController === viewController)
        XCTAssert(window.isKeyWindow)
    }
}
