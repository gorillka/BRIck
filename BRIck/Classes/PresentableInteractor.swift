//
//  PresentableInteractor.swift
//  BRIck
//
//  Created by Gorilka on 8/2/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import UIKit

open class PresentableInteractor<PresenterType: Presentable>: Interactor {
    public private(set) weak var presenter: PresenterType?

    init(presenter: PresenterType) {
        self.presenter = presenter
    }
}
