//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import Combine
import Foundation
import Logging

/// Leak detection status.
public enum LeakDetectionStatus {
    /// Leak detection is in progress.
    case inProgress

    /// Leak detection has completed.
    case didComplete
}

/// The default time values used for leak detection expectations.
public enum LeakDefaultExpectationTime {
    /// The object deallocation time.
    public static let deallocation: Double = 1

    /// The view disappear time.
    public static let viewDisappear: Double = 5
}

/// The handle for a scheduled leak detection.
public protocol LeakDetectionHandler {
    /// Cancel the scheduled detection.
    func cancel()
}

/// An expectation based leak detector, that allows an object's owner to set an expectation that an owned object to be
/// deallocated within a time frame.
///
/// A `Router` that owns an `Interactor` might for example expect its `Interactor` be deallocated when the `Router`
/// itself is deallocated. If the interactor does not deallocate in time, a runtime assert is triggered, along with
/// critical logging.
public class LeakDetector {
    /// The singleton instance.
    public static let shared = LeakDetector()

    // Test override for leak detectors.
    static var disableLeakDetectorOverride = false

    // MARK: - Public Properties

    public var logger: Logger = Logger(label: "BRIck.leakDetector")

    /// The status of leak detection.
    ///
    /// The status changes between `inProgress` and `didComplete` as units register for new detections, cancel existing
    /// detections, and existing detections complete.
    public var status: AnyPublisher<LeakDetectionStatus, Never> {
        expectationCount
            .map { $0 > 0 ? .inProgress : .didComplete }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private lazy var disableLeakDetector: Bool = {
        let environmentValue = ProcessInfo()
            .environment["DISABLE_LEAK_DETECTION"]

        if let flag = environmentValue?.lowercased() {
            return flag == "true" || flag == "yes" || flag == "1"
        }

        return LeakDetector.disableLeakDetectorOverride
    }()

    private let expectationCount = CurrentValueSubject<Int, Never>(0)
    private let trackingObjects = NSMapTable<AnyObject, AnyObject>.strongToWeakObjects()

    // MARK: - Inits

    private init() {}

    #if DEBUG
        /// Reset the state of Leak Detector, internal for UI test only.
        func reset() {
            trackingObjects.removeAllObjects()
            expectationCount.send(0)
        }
    #endif

    /// Sets up an expectation for the given object to be deallocated within the given time.
    ///
    /// - parameter object: The object to track for deallocation.
    /// - parameter in: The time the given object is expected to be deallocated within.
    /// - returns: The handle that can be used to cancel the expectation.
    @discardableResult
    public func expectDeallocateObject(
        _ object: AnyObject,
        in time: TimeInterval = LeakDefaultExpectationTime.deallocation
    ) -> LeakDetectionHandler {
        expectationCount.send(expectationCount.value + 1)

        let objectDescription = String(describing: object)
        let objectId = "\(ObjectIdentifier(object).hashValue)"

        trackingObjects.setObject(object, forKey: objectId as NSString)

        let handle = LeakDetectionHandleImplementation { [weak self] in
            guard let self = self else { return }
            self.expectationCount.send(self.expectationCount.value - 1)
        }

        Executor.execute(delay: time) {
            // Retain the handle so we can check for the cancelled status. Also cannot use the cancellable
            // concurrency API since the returned handle must be retained to ensure closure is executed.
            if handle.cancelled {
                return self.expectationCount.send(self.expectationCount.value - 1)
            }

            let didDeallocate = self.trackingObjects.object(forKey: objectId as NSString) == nil
            let message =
                "<\(objectDescription): \(objectId)> has leaked. Object are expected to be deallocated at this time: \(self.trackingObjects)."

            if self.disableLeakDetector {
                if !didDeallocate {
                    self.logger.debug("Leak detection is disabled. This should only be used for debugging purposes.")
                    self.logger.debug(.init(stringLiteral: message))
                }
            } else {
                if didDeallocate {
                    self.logger.critical(.init(stringLiteral: message))
                }
                assert(didDeallocate, message)
            }
        }

        return handle
    }
    
    /// Sets up an expectation for the given view controller to disappear within the given time.
    ///
    /// - parameter viewController: The `ViewController` expected to disappear.
    /// - parameter in: The time the given view controller is expected to disappear.
    /// - returns: The handle that can be used to cancel the expectation.
    @discardableResult
    public func expectViewControllerDisappear(
        _ viewController: ViewController,
        in time: TimeInterval = LeakDefaultExpectationTime.viewDisappear
    ) -> LeakDetectionHandler {
        expectationCount.send(expectationCount.value + 1)

        let handler = LeakDetectionHandleImplementation {
            self.expectationCount.send(self.expectationCount.value - 1)
        }

        Executor.execute(delay: time) { [weak viewController] in
            // Retain the handle so we can check for the cancelled status. Also cannot use the cancellable
            // concurrency API since the returned handle must be retained to ensure closure is executed.
            guard let viewController = viewController, !handler.cancelled else {
                return self.expectationCount.send(self.expectationCount.value - 1)
            }

            let viewDidDisappear = !viewController.isViewLoaded || viewController.view.window == nil
            let message =
                "\(viewController) appearance has leaked. Either its parent router who does not own a view controller was detached, but failed to dismiss the leaked view controller; or the view controller is reused and re-added to window, yet the router is not re-attached but re-created. Objects are expected to be deallocated at this time: \(self.trackingObjects)"

            if self.disableLeakDetector {
                self.logger.debug("Leak detection is disabled. This should only be used for debugging purposes.")
                self.logger.debug(.init(stringLiteral: message))
            } else {
                if viewDidDisappear {
                    self.logger.critical(.init(stringLiteral: message))
                }
                assert(viewDidDisappear, message)
            }
        }

        return handler
    }
}

private class LeakDetectionHandleImplementation: LeakDetectionHandler {
    var cancelled: Bool { cancelledSubject.value }

    private let cancelledSubject = CurrentValueSubject<Bool, Never>(false)
    private let cancelHandler: (() -> Void)?

    init(cancelHandler: (() -> Void)? = nil) {
        self.cancelHandler = cancelHandler
    }

    func cancel() {
        cancelledSubject.send(true)
        cancelHandler?()
    }
}
