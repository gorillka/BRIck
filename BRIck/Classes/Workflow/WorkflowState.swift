//
//  WorkflowState.swift
//  BRIck
//
//  Created by Artem Orynko on 11/23/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

public enum WorkflowState<Value>: Equatable {
    case pending
    case resolved(value: Value)
    case rejected(error: Error)

    public var result: WorkflowResult<Value>? {
        switch self {
        case .pending:
            return nil
        case let .resolved(value):
            return .success(value: value)
        case let .rejected(error):
            return .failure(error: error)
        }
    }

    public var isPending: Bool {
        return result == nil
    }

    public var isResolved: Bool {
        if case .resolved = self {
            return true
        } else {
            return false
        }
    }

    public var isRejected: Bool {
        if case .rejected = self {
            return true
        } else {
            return false
        }
    }
}

public func ==<Value>(lhs: WorkflowState<Value>, rhs: WorkflowState<Value>) -> Bool {
    return lhs.isPending == rhs.isPending ||
        lhs.isResolved == rhs.isResolved ||
        lhs.isRejected == rhs.isRejected
}
