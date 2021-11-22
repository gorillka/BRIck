//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

@testable import BRIck
import Combine
import XCTest

final class WorkflowTest: XCTestCase {
    func test_nestedStepsDoNotRepeat() {
        var outerStep1RunCount = 0
        var outerStep2RunCount = 0
        var outerStep3RunCount = 0

        var innerStep1RunCount = 0
        var innerStep2RunCount = 0
        var innerStep3RunCount = 0

        let emptyPublisher = Just(((), ()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let workflow = Workflow<String>()
        workflow
            .on { _ -> AnyPublisher<(Void, Void), Error> in
                outerStep1RunCount += 1

                return emptyPublisher
            }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                outerStep2RunCount += 1

                return emptyPublisher
            }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                outerStep3RunCount += 1

                let innerStep: Step<String, Void, Void>? = emptyPublisher
                    .fork(workflow)
                innerStep?
                    .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                        innerStep1RunCount += 1

                        return emptyPublisher
                    }
                    .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                        innerStep2RunCount += 1

                        return emptyPublisher
                    }
                    .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                        innerStep3RunCount += 1

                        return emptyPublisher
                    }
                    .commit()

                return emptyPublisher
            }
            .commit()
            .subscribe("Test Actionable Item")

        XCTAssertEqual(outerStep1RunCount, 1, "Outer step 1 should not have been run more than once")
        XCTAssertEqual(outerStep2RunCount, 1, "Outer step 2 should not have been run more than once")
        XCTAssertEqual(outerStep3RunCount, 1, "Outer step 3 should not have been run more than once")

        XCTAssertEqual(innerStep1RunCount, 1, "Inner step 1 should not have been run more than once")
        XCTAssertEqual(innerStep2RunCount, 1, "Inner step 2 should not have been run more than once")
        XCTAssertEqual(innerStep3RunCount, 1, "Inner step 3 should not have been run more than once")
    }

    func test_workflowReceivesError() {
        let workflow = TestWorkflow()

        let emptyPublisher = Just(((), ()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        workflow
            .on { _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                Fail<(Void, Void), WorkflowTestError>(error: WorkflowTestError.error)
                    .mapError { $0 }
                    .eraseToAnyPublisher()
            }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
            .commit()
            .subscribe(())

        XCTAssertEqual(0, workflow.completeCallCount)
        XCTAssertEqual(0, workflow.forkCallCount)
        XCTAssertEqual(1, workflow.errorCallCount)
    }

    func test_workflowDidComplete() {
        let workflow = TestWorkflow()

        let emptyPublisher = Just(((), ()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        workflow
            .on { _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
            .commit()
            .subscribe(())

        XCTAssertEqual(1, workflow.completeCallCount)
        XCTAssertEqual(0, workflow.forkCallCount)
        XCTAssertEqual(0, workflow.errorCallCount)
    }

    func test_workflowDidFork() {
        let workflow = TestWorkflow()

        let emptyPublisher = Just(((), ()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        workflow
            .on { _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                let forkedStep: Step<Void, Void, Void>? = emptyPublisher
                    .fork(workflow)
                forkedStep?
                    .on { _, _ -> AnyPublisher<(Void, Void), Error> in emptyPublisher }
                    .commit()

                return emptyPublisher
            }
            .commit()
            .subscribe(())

        XCTAssertEqual(1, workflow.completeCallCount)
        XCTAssertEqual(1, workflow.forkCallCount)
        XCTAssertEqual(0, workflow.errorCallCount)
    }

    func test_fork_verifySingleInvocationAtRoot() {
        let workflow = TestWorkflow()

        var rootCallCount = 0
        let emptyPublisher = Just(((), ()))
        let rootStep = workflow
            .on { _ -> AnyPublisher<(Void, Void), Error> in
                rootCallCount += 1

                return emptyPublisher
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

        let firstFork: Step<Void, Void, Void>? = rootStep
            .fork(workflow)

        _ = firstFork?
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                Just(((), ()))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .commit()

        let secondFork: Step<Void, Void, Void>? = rootStep
            .fork(workflow)

        _ = secondFork?
            .on { _, _ -> AnyPublisher<(Void, Void), Error> in
                Just(((), ()))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .commit()

        XCTAssertEqual(0, rootCallCount)

        _ = workflow.subscribe(())

        XCTAssertEqual(1, rootCallCount)
    }
}

private enum WorkflowTestError: Error {
    case error
}

private class TestWorkflow: Workflow<Void> {
    var completeCallCount = 0
    var errorCallCount = 0
    var forkCallCount = 0

    override func didComplete() {
        completeCallCount += 1
    }

    override func didFork() {
        forkCallCount += 1
    }

    override func didReceive(_ error: Error) {
        errorCallCount += 1
    }
}
