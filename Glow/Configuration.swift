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
                swap(&(rows[coord.y].items[coord.x]), &(rows[coord.y].items[coord.x - 1]))
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
                swap(&(rows[coord.y].items[coord.x]), &(rows[coord.y].items[coord.x + 1]))
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
                swap(&(rows[coord.y - 1].items[coord.x]), &(rows[coord.y].items[coord.x]))
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
                swap(&(rows[coord.y].items[coord.x]), &(rows[coord.y + 1].items[coord.x]))
                return Configuration(rows)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
