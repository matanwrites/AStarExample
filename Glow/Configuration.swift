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
    let items: Array<String>
    
    init(_ items: Array<String>) {
        self.items = items
    }
}

struct Configuration {
    let rows: Array<Row>
    let coordinate: Coordinate?
    
    init(_ rows: Array<Row>) {
        self.rows = rows
        for (y, row) in enumerate(self.rows) {
            for (x, item) in enumerate(row.items) {
                if item == kBlank {
                    self.coordinate = Coordinate(x, y)
                }
            }
        }
    }
    
    func left() -> Configuration? {
        if let coord = self.coordinate {
            if coord.x > 0 {
                let newRows = self.rows
                let newRow = newRows[coord.y]
                let blank = newRow.items[coord.x]
                let leftOne = newRow.items[coord.x - 1]
                newRow.items[coord.x - 1] = blank
                newRow.items[coord.x] = leftOne
                newRows[coord.y] = newRow
                return Configuration(newRows)
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
                let newRows = self.rows
                let newRow = newRows[coord.y]
                let blank = newRow.items[coord.x]
                let rightOne = newRow.items[coord.x + 1]
                newRow.items[coord.x + 1] = blank
                newRow.items[coord.x] = rightOne
                newRows[coord.y] = newRow
                return Configuration(newRows)
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
                let newRows = self.rows
                let newRow0 = newRows[coord.y - 1]
                let upOne = newRow0.items[coord.x]
                let newRow1 = newRows[coord.y]
                let blank = newRow1.items[coord.x]
                newRow0.items[coord.x] = blank
                newRow1.items[coord.x] = upOne
                newRows[coord.y - 1] = newRow0
                newRows[coord.y] = newRow1
                return Configuration(newRows)
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
                let newRows = self.rows
                let newRow0 = newRows[coord.y]
                let blank = newRow0.items[coord.x]
                let newRow1 = newRows[coord.y + 1]
                let downOne = newRow1.items[coord.x]
                newRow0.items[coord.x] = downOne
                newRow1.items[coord.x] = blank
                newRows[coord.y] = newRow0
                newRows[coord.y + 1] = newRow1
                return Configuration(newRows)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
