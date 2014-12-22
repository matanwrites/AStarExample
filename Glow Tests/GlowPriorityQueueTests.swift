//
//  GlowPriorityQueueTests.swift
//  Glow
//
//  Created by Yan Li on 12/18/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

import Cocoa
import XCTest

class GlowPriorityQueueTests: XCTestCase {

    func testMultipleInstances() {
        let queue1 = GlowPriorityQueue()
        queue1.addObject("1", withPriority: 1);
        queue1.addObject("2", withPriority: 2);
        
        let queue2 = GlowPriorityQueue()
        queue2.addObject("2", withPriority: 2);
        queue2.addObject("1", withPriority: 1);
        
        let queue1Minimum = queue1.removeFirstObject() as? String
        let queue2Minimum = queue2.removeFirstObject() as? String
        
        XCTAssert(queue1Minimum == "1")
        XCTAssert(queue2Minimum == "1")
    }
    
    func testAppend() {
        let queue = GlowPriorityQueue()
        
        let cases = [1, 10, 9, 8, 5, 100, 4]
        for (index, a) in enumerate(cases) {
            queue.addObject(a, withPriority: a)
        }
        
        let sortedCases = cases.sorted { (a, b) -> Bool in
            return a < b
        }
        for (index, a) in enumerate(sortedCases) {
            XCTAssert(queue.containsObject(a))
            
            let shift = queue.removeFirstObject() as Int
            XCTAssert(shift == a)
        }
    }

}
