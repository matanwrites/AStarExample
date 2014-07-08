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

let kUp    = "U"
let kDown  = "D"
let kLeft  = "L"
let kRight = "R"

@infix func - (left: Configuration, right: Configuration) -> Int {
    var result: Int = 0
    for (y, row) in enumerate(left.rows) {
        for (x, items) in enumerate(row.items) {
            let leftItem = left.rows[y].items[x]
            let rightItem = right.rows[y].items[x]
            result += leftItem != rightItem ? 1 : 0
        }
    }
    return result
}

struct Coordinate {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

struct Row {
    var items: [String]
    
    init(_ items: [String]) {
        self.items = items
    }
}

struct Configuration {
    var rows: [Row]
    let coordinate: Coordinate?
    
    init(_ rows: [Row]) {        
        self.rows = rows
        for (y, row) in enumerate(self.rows) {
            for (x, item) in enumerate(row.items) {
                if item == kBlank {
                    self.coordinate = Coordinate(x, y)
                }
            }
        }
    }
    
    func swapItemsInRow(inout #itemA: String, inout itemB: String) {
        var temp = itemA
        itemA = itemB
        itemB = temp
    }
    
    func left() -> Configuration? {
        if let coord = self.coordinate {
            if coord.x > 0 {
                var current = rows[coord.y].items[coord.x]
                var left = rows[coord.y].items[coord.x - 1]
                swapItemsInRow(itemA: &current, itemB: &left)
                return Configuration(rows)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func right() -> Configuration? {
        if let coord = self.coordinate {
            if coord.x + 1 < self.rows[coord.y].items.count {
                var current = rows[coord.y].items[coord.x]
                var right = rows[coord.y].items[coord.x + 1]
                swapItemsInRow(itemA: &current, itemB: &right)
                return Configuration(rows)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func up() -> Configuration? {
        if let coord = self.coordinate {
            if coord.y > 0 {
                var current = rows[coord.y].items[coord.x]
                var up = rows[coord.y - 1].items[coord.x]
                swapItemsInRow(itemA: &current, itemB: &up)
                return Configuration(rows)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func down() -> Configuration? {
        if let coord = self.coordinate {
            if coord.y + 1 < self.rows.count {
                var current = rows[coord.y].items[coord.x]
                var down = rows[coord.y + 1].items[coord.x]
                swapItemsInRow(itemA: &current, itemB: &down)
                return Configuration(rows)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
