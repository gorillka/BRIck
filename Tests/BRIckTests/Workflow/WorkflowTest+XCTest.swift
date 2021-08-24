//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import XCTest

extension WorkflowTest {
    static var allTests: [(String, (WorkflowTest) -> () throws -> Void)] {
        [
            ("test_nestedStepsDoNotRepeat", test_nestedStepsDoNotRepeat),
            ("test_workflowReceivesError", test_workflowReceivesError),
            ("test_workflowDidComplete", test_workflowDidComplete),
            ("test_workflowDidFork", test_workflowDidFork),
            ("test_fork_verifySingleInvocationAtRoot", test_fork_verifySingleInvocationAtRoot),
        ]
    }
}
