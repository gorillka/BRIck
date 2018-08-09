//
//  PresentableInteractor.swift
//  BRIck
//
//  Created by Gorilka on 8/2/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import UIKit

/// Base class of an `Interactor` that actually has an associated `Presenter` and `View`.
open class PresentableInteractor<PresenterType>: Interactor {

    /// The `Presenter` associated with this `Interactor`.
    let presenter: PresenterType

    /// Initializer.
    ///
    /// - Note: This holds a strong reference to the given `Presenter`.
    ///
    /// - Parameter presenter: The `Presenter` associated with this `Interactor`.
    public init(presenter: PresenterType) {
        self.presenter = presenter
    }
}
