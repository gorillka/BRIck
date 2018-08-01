//
//  Array+.swift
//  BRIck
//
//  Created by Gorilka on 8/1/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeByReference(_ element: Element) {
        guard let index = index(where: { $0 as AnyObject === element as AnyObject }) else {
            return
        }

        remove(at: index)
    }
}
