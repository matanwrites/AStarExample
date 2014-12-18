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

func - (left: Configuration, right: Configuration) -> Int {
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
    
    func left() -> Configuration? {
        if let coord = self.coordinate {
            if coord.x > 0 {
                var rows = self.rows
                var items = rows[coord.y].items
                swap(&items[coord.x], &items[coord.x - 1])
                rows[coord.y].items = items
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
                var rows = self.rows
                var items = rows[coord.y].items
                swap(&items[coord.x], &items[coord.x + 1])
                rows[coord.y].items = items
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
                var rows = self.rows
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
                var rows = self.rows
                swap(&(rows[coord.y].items[coord.x]), &(rows[coord.y + 1].items[coord.x]))
                return Configuration(rows)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    
    // MARK: A* Algorithm
    let g_score: Int = 0
    let f_score: Int = 0
    
}
