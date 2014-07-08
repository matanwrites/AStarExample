// Playground - noun: a place where people can play

import Cocoa
import XCPlayground

let kBlank = "_"
let kRed   = "R"
let kBlue  = "B"

struct Coordinate {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
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

struct Row {
    let items: Array<String>
    
    init(_ items: Array<String>) {
        self.items = items
    }
}

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

let kDefault = Configuration([
    Row([kBlank, kRed, kBlue, kBlue]),
    Row([kRed, kRed, kBlue, kBlue]),
    Row([kRed, kRed, kBlue, kBlue]),
    Row([kRed, kRed, kBlue, kBlue]),
])
kDefault.coordinate

let step1 = kDefault.right()
step1?.coordinate

let step2 = step1?.left()?
step2?.coordinate

let setp3 = step2?.down()?
setp3?.coordinate

let step4 = setp3?.up()?
step4?.coordinate

let kTarget = Configuration([
    Row([kBlank, kBlue, kRed, kBlue]),
    Row([kBlue, kRed, kBlue, kRed]),
    Row([kRed, kBlue, kRed, kBlue]),
    Row([kBlue, kRed, kBlue, kRed]),
])
kTarget.coordinate

kTarget - kDefault

var config: Configuration? = kDefault
var score = 16

while config {
    XCPCaptureValue("Score Down", kTarget - config!)
    config = config!.down()
}

config = kDefault
while config {
    XCPCaptureValue("Score Right", kTarget - config!)
    config = config!.right()
}

//while kTarget - config > 0 {
//    if let up = config.up() {
//        let upScore = kTarget - up
//        if upScore <= score {
//            score = upScore
//            config = up
//        }
//    }
//    
//    if let down = config.down() {
//        let downScore = kTarget - down
//        if downScore <= score {
//            score = downScore
//            config = down
//        }
//    }
//    
//    if let left = config.left() {
//        let leftScore = kTarget - left
//        if leftScore <= score {
//            score = leftScore
//            config = left
//        }
//    }
//    
//    if let right = config.right() {
//        let rightScore = kTarget - right
//        if rightScore <= score {
//            score = rightScore
//            config = right
//        }
//    }
//    
//    XCPCaptureValue("Score", score)
//}


