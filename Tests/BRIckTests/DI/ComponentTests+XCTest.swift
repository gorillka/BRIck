//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import XCTest

extension ComponentTests {
    static var allTests: [(String, (ComponentTests) -> () throws -> Void)] {
        [
            ("test_shared", test_shared),
            ("test_shared_optional", test_shared_optional),
        ]
    }
}
