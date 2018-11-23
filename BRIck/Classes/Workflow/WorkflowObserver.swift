//
//  WorkflowObserver.swift
//  BRIck
//
//  Created by Artem Orynko on 11/23/18.
//  Copyright © 2018 Gorilka. All rights reserved.
//

struct WorkflowObserver<Value> {
    let queue: DispatchQueue
    let notify: (WorkflowResult<Value>) -> Void
}
