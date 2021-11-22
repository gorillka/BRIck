
import XCTest

extension WorkerTests {
    static var allTests: [(String, (WorkerTests) -> () throws -> Void)] {
        [
            ("test_didStart_onceOnly_boundToInteractor", test_didStart_onceOnly_boundToInteractor),
            ("test_start_stop_lifecycle", test_start_stop_lifecycle)
        ]
    }
}
