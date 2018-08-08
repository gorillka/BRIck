//
//  ViewControllable.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import UIKit

public protocol ViewControllable: class {
    var uiViewController: UIViewController { get }
}

public extension ViewControllable where Self: UIViewController {
    var uiViewController: UIViewController {
        return self
    }
}
