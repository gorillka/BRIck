//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import BRIck
import Combine
import UIKit

class InteractorMock: Interactable {
    var isActive: Bool { active.value }

    var isActiveStream: AnyPublisher<Bool, Never> { active.eraseToAnyPublisher() }

    private let active = CurrentValueSubject<Bool, Never>(false)

    init() {}

    func activate() {
        active.send(true)
    }

    func deactivate() {
        active.send(false)
    }
}

class InteractableMock: Interactable {
    var isActiveSetCount = 0
    var isActiveStreamSubjectCallCount = 0

    var isActive = false {
        didSet { isActiveSetCount += 1 }
    }

    var isActiveSubject = PassthroughSubject<Bool, Never>() {
        didSet { isActiveStreamSubjectCallCount += 1 }
    }

    var isActiveStream: AnyPublisher<Bool, Never> {
        isActiveSubject.eraseToAnyPublisher()
    }

    var activateCallCount = 0
    var deactivateCallCount = 0
    var activateHandler: (() -> Void)?
    var deactivateHandler: (() -> Void)?

    init() {}

    func activate() {
        activateCallCount += 1
        activateHandler?()
    }

    func deactivate() {
        deactivateCallCount += 1
        deactivateHandler?()
    }
}

class ViewControllerMock: UIViewController, ViewControllable {}

class WindowMock: UIWindow {
    
    private var internalIsKeyWindow = false
    private var internalRootViewController: UIViewController?
    
    override var isKeyWindow: Bool { internalIsKeyWindow }
    
    override var rootViewController: UIViewController? {
        get { internalRootViewController }
        set { internalRootViewController = newValue }
    }
    
    override func makeKeyAndVisible() {
        internalIsKeyWindow = true
    }
}
