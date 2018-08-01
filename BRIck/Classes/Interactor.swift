//
//  Interactor.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

public protocol InteractorScope: class {
    typealias ActivityHandler = (Bool) -> Swift.Void
    var isActive: Bool { get }
    var activityHandler: ActivityHandler? { get set }
}

public protocol Interactable: InteractorScope {
    func activate()
    func deactivate()
}

open class Interactor: Interactable {
    public var activityHandler: ActivityHandler?

    public private(set) var isActive: Bool = false {
        didSet {
            activityHandler?(isActive)
        }
    }

    public init() {}

    open func didBecomeActive() {}
    open func willResignActive() {}

    public func activate() {
        guard !isActive else {
            return
        }

        isActive = true

        didBecomeActive()
    }

    public func deactivate() {
        guard isActive else {
            return
        }

        willResignActive()

        isActive = false
    }

    deinit {
        if isActive {
            deactivate()
        }

        activityHandler = nil
    }
}
