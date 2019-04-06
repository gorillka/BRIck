//
//  Interactable.swift
//  BRIck
//
//  Created by Artem Orynko on 4/6/19.
//  Copyright © 2019 Gorilka. All rights reserved.
//

/// The base protocol for all interactors.
public protocol Interactable: InteractorScope {
    /// Activate this interactor.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application code should never explicitly invoke this method.
    func activate()

    /// Deactivate this interactor.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application code should never explicitly invoke this method.
    func deactivate()
}

extension Interactable where Self: Interactor {
    /// Activate the `Interactor`.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application code should never explicitly invoke this method.
    public func activate() {
        guard !isActive else { return }

        isActive = true

        didBecomeActive()
    }

    /// Deactivate this `Interactor`.
    ///
    /// - Note: This method is internally invoked by the corresponding router. Application should never explicitly invoke this method.
    public func deactivate() {
        guard isActive else { return }

        willResignActive()

        isActive = false
    }
}
