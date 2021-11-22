//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import XCTest

#if os(Linux) || os(FreeBSD)
@testable import BRIckTests

var tests = [XCTestCaseEntry]()
tests += BRIckTests.allTests()
tests += WorkerTests.allTests()
tests += WorkflowTest.allTests()
tests += ComponentTests.allTests()
tests += RouterTests.allTests()
tests += LaunchRouterTests.allTests()
XCTMain(tests)
