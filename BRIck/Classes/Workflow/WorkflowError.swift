//
//  WorkflowError.swift
//  BRIck
//
//  Created by Artem Orynko on 11/23/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

public enum WorkflowError: Error {
    case cancelled
}

public enum FailurePolicy {
    case allErrors
    case notCancelled
}
