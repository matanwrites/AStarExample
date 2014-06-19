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


