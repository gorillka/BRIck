import XCTest

extension RouterTests {
    static var allTests: [(String, (RouterTests) -> () throws -> Void)] {
        [
            ("test_load_verifyLifecycleObservable", test_load_verifyLifecycleObservable)
        ]
    }
}
