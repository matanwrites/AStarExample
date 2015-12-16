//
//  Brain.swift
//  Glow
//
//  Created by Yan Li on 6/9/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

import Cocoa

let kBlank = 0
let kRed   = 1
let kBlue  = 2

let kUp    = "U"
let kDown  = "D"
let kLeft  = "L"
let kRight = "R"

func - (left: Configuration, right: Configuration) -> Int {
    var result: Int = 0
    for (y, row) in left.rows.enumerate() {
        for (x, _) in row.items.enumerate() {
            let leftItem = left.rows[y].items[x]
            let rightItem = right.rows[y].items[x]
            result += (leftItem != rightItem ? 1 : 0)
        }
    }
    return result
}

func ==(lhs: Configuration, rhs: Configuration) -> Bool {
    return lhs.hashValue == rhs.hashValue
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
    var items: [Int]
    
    var displayName: String {
        get {
            return self.items.combine("")
        }
    }
    
    init(_ items: [Int]) {
        self.items = items
    }
}

class Configuration: NSObject {
    var rows: [Row]
    let coordinate: Coordinate?
    
    override var hashValue: Int {
        get {
            return actualHash
        }
    }
    
    let actualHash: Int
    
    init(_ rows: [Row], x: Int, y: Int) {
        self.rows = rows
        self.coordinate = Coordinate(x, y)
        
        var result = ""
        for row in rows {
            result += row.displayName
        }
        actualHash = result.hashValue
    }
    
    var neighbors: [String : Configuration] {
        get {
            var result = [String : Configuration]()
            
            if let left = left() {
                result[kLeft] = left
            }
            
            if let right = right() {
                result[kRight] = right
            }
            
            if let up = up() {
                result[kUp] = up
            }
            
            if let down = down() {
                result[kDown] = down
            }
            
            return result
        }
    }
    
    func left() -> Configuration? {
        if let coord = self.coordinate {
            if coord.x > 0 {
                var rows = self.rows
                var items = rows[coord.y].items
                swap(&items[coord.x], &items[coord.x - 1])
                rows[coord.y].items = items
                return Configuration(rows, x: coord.x - 1, y: coord.y)
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
                return Configuration(rows, x: coord.x + 1, y: coord.y)
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
                return Configuration(rows, x: coord.x, y: coord.y - 1)
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
                return Configuration(rows, x: coord.x, y: coord.y + 1)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
