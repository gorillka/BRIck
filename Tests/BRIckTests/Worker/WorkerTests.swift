//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

@testable import BRIck
import Combine
import XCTest

final class WorkerTests: XCTestCase {
    private var worker: TestWorker!
    private var interactor: InteractorMock!
    private var store = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        store = []

        worker = .init()
        interactor = .init()
    }

    func test_didStart_onceOnly_boundToInteractor() {
        XCTAssertEqual(worker.didStartCallCount, 0)
        XCTAssertEqual(worker.didStopCallCount, 0)

        worker.start(interactor)

        XCTAssertTrue(worker.isStarted)
        XCTAssertEqual(worker.didStartCallCount, 0)
        XCTAssertEqual(worker.didStopCallCount, 0)

        interactor.activate()

        XCTAssertTrue(worker.isStarted)
        XCTAssertEqual(worker.didStartCallCount, 1)
        XCTAssertEqual(worker.didStopCallCount, 0)

        interactor.deactivate()

        XCTAssertTrue(worker.isStarted)
        XCTAssertEqual(worker.didStartCallCount, 1)
        XCTAssertEqual(worker.didStopCallCount, 1)

        worker.start(interactor)

        XCTAssertTrue(worker.isStarted)
        XCTAssertEqual(worker.didStartCallCount, 1)
        XCTAssertEqual(worker.didStopCallCount, 1)

        interactor.activate()

        XCTAssertTrue(worker.isStarted)
        XCTAssertEqual(worker.didStartCallCount, 2)
        XCTAssertEqual(worker.didStopCallCount, 1)

        worker.stop()

        XCTAssertFalse(worker.isStarted)
        XCTAssertEqual(worker.didStartCallCount, 2)
        XCTAssertEqual(worker.didStopCallCount, 2)

        worker.stop()

        XCTAssertFalse(worker.isStarted)
        XCTAssertEqual(worker.didStartCallCount, 2)
        XCTAssertEqual(worker.didStopCallCount, 2)
    }

    func test_start_stop_lifecycle() {
        worker
            .isStartedStream
            .prefix(1)
            .sink { XCTAssertFalse($0) }
            .store(in: &store)

        interactor.activate()
        worker.start(interactor)

        worker
            .isStartedStream
            .prefix(1)
            .sink { XCTAssertTrue($0) }
            .store(in: &store)

        worker.stop()

        worker
            .isStartedStream
            .prefix(1)
            .sink { XCTAssertFalse($0) }
            .store(in: &store)
    }
}

// MARK: - TestWorker

private final class TestWorker: Worker {
    private(set) var didStartCallCount = 0
    private(set) var didStopCallCount = 0

    // MARK: - Override Methods

    override func didStart(_ interactorScope: InteractorScope) {
        super.didStart(interactorScope)
        didStartCallCount += 1
    }

    override func didStop() {
        super.didStop()

        didStopCallCount += 1
    }
}
