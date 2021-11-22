@testable import BRIck
import Combine
import XCTest

final class RouterTests: XCTestCase {
    private var router: Router<Interactable>!
    private var cancellable: AnyCancellable!
    
    override func setUp() {
        super.setUp()
        
        router = Router(interactor: InteractableMock())
    }
    
    override func tearDown() {
        super.tearDown()
        
        cancellable.cancel()
    }
    
    func test_load_verifyLifecycleObservable() {
        var isActive: Void?
        var didComplete = false
        cancellable = router
            .lifecycle
            .sink(receiveCompletion: { _ in
                isActive = nil
                didComplete = true
            }, receiveValue: {
                isActive = $0
            })
        
        XCTAssertNil(isActive)
        XCTAssertFalse(didComplete)
        
        router.load()
        
        XCTAssertNotNil(isActive)
        XCTAssertFalse(didComplete)
        
        router = nil
        
        XCTAssertNil(isActive)
        XCTAssertTrue(didComplete)
    }
}
