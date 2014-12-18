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
        let queue1 = GlowPriorityQueue() { (obj1, obj2) -> CFComparisonResult in
            return .CompareGreaterThan
        }
        
        queue1.addObject("1");
        queue1.addObject("2");
        
        let queue2 = GlowPriorityQueue() { (obj1, obj2) -> CFComparisonResult in
            return .CompareLessThan
        }
        
        queue2.addObject("1");
        queue2.addObject("2");
        
        let queue1Minimum = queue1.shift() as? String
        let queue2Minimum = queue2.shift() as? String
        
        XCTAssert(queue1Minimum == "2")
        XCTAssert(queue2Minimum == "1")
    }
    
    func testAppend() {
        let queue = GlowPriorityQueue() { (obj1, obj2) -> CFComparisonResult in
            let number1 = obj1 as Int
            let number2 = obj2 as Int
            
            if number1 > number2 {
                return .CompareGreaterThan
            } else if number1 < number2 {
                return .CompareLessThan
            } else {
                return .CompareEqualTo
            }
        }
        
        let cases = [1, 10, 9, 8, 5, 100, 4]
        for (index, a) in enumerate(cases) {
            queue.addObject(a)
        }
        
        let sortedCases = cases.sorted { (a, b) -> Bool in
            return a < b
        }
        for (index, a) in enumerate(sortedCases) {
            let shift = queue.shift() as Int
            XCTAssert(shift == a)
        }
    }

}
