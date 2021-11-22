//
//  File.swift
//  File
//
//  Created by Artem Orynko on 16.08.2021.
//

import XCTest
import Combine
@testable import BRIck

final class ComponentTests: XCTestCase {
    func test_shared() {
        let component = TestComponent(dependency: EmptyComponent())
        XCTAssert(component.share1 === component.share1, "Should have returned same shred object.")
        
        XCTAssertTrue(component.share2 === component.share2)
        XCTAssertFalse(component.share1 === component.share2)
        
        XCTAssertEqual(component.callCount, 3)
    }
    
    func test_shared_optional() {
        let component = TestComponent(dependency: EmptyComponent())
        XCTAssert(component.optionalShare === component.expectedOptionalShare, "Should have returned same shared object.")
    }
}

private final class TestComponent: Component<EmptyComponent> {
    private(set) var callCount = 0
    private(set) var expectedOptionalShare: ClassProtocol? = { ClassProtocolImplementation() }()
    
    var share1: NSObject {
        callCount += 1
        
        return shared { NSObject() }
    }
    
    var share2: NSObject {
        shared { NSObject() }
    }
    
    fileprivate var optionalShare: ClassProtocol? {
        shared { self.expectedOptionalShare }
    }
}

private protocol ClassProtocol: AnyObject {}
private final class ClassProtocolImplementation: ClassProtocol {}
