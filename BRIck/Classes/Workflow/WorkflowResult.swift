//
//  WorkflowResult.swift
//  BRIck
//
//  Created by Artem Orynko on 11/23/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

import Foundation

public enum WorkflowResult<Value> {
    case success(value: Value)
    case failure(error: Error)

    public var value: Value? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }

    public var error: Error? {
        switch self {
        case let .failure(error):
            return error
        case .success:
            return nil
        }
    }

    public func map<T>(_ transform: (Value) throws -> T) rethrows -> WorkflowResult<T> {
        switch self {
        case let .success(value):
            return .success(value: try transform(value))
        case let .failure(error):
            return WorkflowResult<T>.failure(error: error)
        }
    }
}
