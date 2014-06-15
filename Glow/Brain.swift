//
//  Brain.swift
//  Glow
//
//  Created by Yan Li on 6/9/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

import Cocoa

let kBlank = "_"
let kRed   = "R"
let kBlue  = "B"

let kDataChangeNotificationName = "com.eyeplum.data_changed"
let kDefaultSteps = ""
let kDefaultConfiguration = [
    [kBlank, kRed, kBlue, kBlue],
    [kRed, kRed, kBlue, kBlue],
    [kRed, kRed, kBlue, kBlue],
    [kRed, kRed, kBlue, kBlue],
]
let kDestinationConfiguration = [
    [kBlank, kBlue, kRed, kBlue],
    [kBlue, kRed, kBlue, kRed],
    [kRed, kBlue, kRed, kBlue],
    [kBlue, kRed, kBlue, kRed],
]

class Brain: NSObject {
    
    class func activeBrain() -> Brain {
        struct Static {
            static let active_brain = Brain()
        }

        return Static.active_brain
    }
    
    var x: Int = 0
    var y: Int = 0
    var steps: String = kDefaultSteps
    var configuration = kDefaultConfiguration
    
    func printConfiguration() {
        NSNotificationCenter.defaultCenter().postNotificationName(
            kDataChangeNotificationName,
            object: self)
    }

    func swapInRow(moveRight: Bool) {
        let row = configuration[y]
        let currentX = x
        x += moveRight ? 1 : -1
        let temp = row[x]
        row[x] = row[currentX]
        row[currentX] = temp
        configuration[y] = row
    }

    func swapBetweenRows(moveDown: Bool) {
        let currentX = x
        let currentY = y
        let currentRow = configuration[y]
        y += moveDown ? 1 : -1
        let neighborRow = configuration[y]
        let temp = currentRow[currentX]
        currentRow[currentX] = neighborRow[currentX]
        neighborRow[currentX] = temp
        configuration[currentY] = currentRow
        configuration[y] = neighborRow
    }
    
    func L() {
        if x > 0 {
            steps = steps.stringByAppendingString("L")
            swapInRow(false)
            printConfiguration()
        } else {
            println("[WARN] Can't move left!")
        }
    }
    
    func R() {
        if x < 3 {
            steps = steps.stringByAppendingString("R")
            swapInRow(true)
            printConfiguration()
        } else {
            println("[WARN] Can't move right!")
        }
    }
    
    func U() {
        if y > 0 {
            steps = steps.stringByAppendingString("U")
            swapBetweenRows(false)
            printConfiguration()
        } else {
            println("[WARN] Can't move up!")
        }
    }
    
    func D() {
        if y < 3 {
            steps = steps.stringByAppendingString("D")
            swapBetweenRows(true)
            printConfiguration()
        } else {
            println("[WARN] Can't move down!")
        }
    }
    
    func reset() {
        x = 0
        y = 0
        steps = kDefaultSteps
        configuration = kDefaultConfiguration
        printConfiguration()
    }
    
}
