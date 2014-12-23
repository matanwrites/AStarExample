//
//  ViewController.swift
//  Glow
//
//  Created by Yan Li on 6/9/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

import Cocoa
import QuartzCore

let kSpacing: CGFloat = 2

extension Array {
    func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }
}

class ViewController: NSViewController {
    
    @IBOutlet var cellContainer: NSView!
    @IBOutlet var stepLabel: NSTextField!
    @IBOutlet var scoreLabel: NSTextField!
    @IBOutlet var coordinateLabel: NSTextField!
    
    var defaultData: Configuration {
    get {
        return Configuration([
            Row([kBlank, kRed, kBlue, kBlue]),
            Row([kRed, kRed, kBlue, kBlue]),
            Row([kRed, kRed, kBlue, kBlue]),
            Row([kRed, kRed, kBlue, kBlue]),
            ], x: 0, y: 0)
    }
    }
    
    var targetData: Configuration {
    get {
        return Configuration([
            Row([kBlank, kBlue, kRed, kBlue]),
            Row([kBlue, kRed, kBlue, kRed]),
            Row([kRed, kBlue, kRed, kBlue]),
            Row([kBlue, kRed, kBlue, kRed]),
            ], x: 0, y: 0)
    }
    }
    
    var data: Configuration?
    
    var stepStack: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellContainer.layer = CALayer()
        cellContainer.wantsLayer = true
        
        self.coordinateLabel.stringValue = ""
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            kKeyboardEventNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { (notification: NSNotification!) -> () in
                if let tagObject : AnyObject = notification.userInfo![kUserInfoKeyTag] {
                    let keyTag: Int = tagObject as Int
                    self.handleKeyboardEvent(keyTag)
                }
            })
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        data = defaultData
        render()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window!.styleMask |= NSFullSizeContentViewWindowMask
        view.window!.titlebarAppearsTransparent = true
        view.window!.titleVisibility = .Hidden
        view.window!.movableByWindowBackground = true
    }
    
    override func viewDidDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewDidDisappear()
    }
    
    func handleKeyboardEvent(keyTag: Int) {
        switch keyTag {
        case kTagUp:
            if let newData = data!.up() {
                data = newData
                stepStack.append(kUp)
            }
        case kTagDown:
            if let newData = data!.down() {
                data = newData
                stepStack.append(kDown)
            }
        case kTagLeft:
            if let newData = data!.left() {
                data = newData
                stepStack.append(kLeft)
            }
        case kTagRight:
            if let newData = data!.right() {
                data = newData
                stepStack.append(kRight)
            }
        case kTagReset:
            data = defaultData
            stepStack.removeAll(keepCapacity: false)
        case kTagTarget:
            data = targetData
            stepStack.removeAll(keepCapacity: false)
        case kTagUndo:
            if stepStack.count > 0 {
                let last = stepStack.removeLast()
                switch last {
                case kUp:
                    data = data!.down()
                case kDown:
                    data = data!.up()
                case kLeft:
                    data = data!.right()
                case kRight:
                    data = data!.left()
                default:
                    break;
                }
            }
        case kTagCopy:
            let pastboard = NSPasteboard.generalPasteboard()
            pastboard.clearContents()
            pastboard.writeObjects([stepStack.combine("")])
        case kTagFindPath:
            dispatch_async(dispatch_queue_create("A*", DISPATCH_QUEUE_SERIAL)) {
                self.AStarAlgorithom(self.defaultData, goal: self.targetData)
            }
        default:
            break;
        }
        
        render()
    }
    
    func render() {
        cellContainer.layer!.sublayers = nil
        stepLabel.stringValue = stepStack.combine("")
        
        if let validData = data {
            scoreLabel.stringValue = "\(targetData - validData)"
        }
        
        let containerWidth = NSWidth(cellContainer.bounds)
        let width = containerWidth / 4
        let cellWidth = width - kSpacing
        
        let rows = data!.rows.count - 1
        let columns = data!.rows[0].items.count - 1
        
        for x in 0...rows {
            for y in 0...columns {
                let cell = CALayer()
                cell.frame = CGRectMake(CGFloat(x) * width, containerWidth - CGFloat(y + 1) * width, cellWidth, cellWidth)
                
                switch data!.rows[y].items[x] as Int {
                case kBlank:
                    cell.backgroundColor = NSColor.whiteColor().CGColor
                case kRed:
                    cell.backgroundColor =
                        NSColor(calibratedRed: 1, green: 60.0/255, blue: 60.0/255, alpha: 0.7).CGColor
                case kBlue:
                    cell.backgroundColor =
                        NSColor(calibratedRed: 0, green: 100.0/255, blue: 1, alpha: 0.7).CGColor
                default:
                    return
                }
                
                cellContainer.layer!.addSublayer(cell)
            }
        }
    }
    
    
    // MARK: A* Algorithom
    
    func AStarAlgorithom(start: Configuration, goal: Configuration) {
        var startTimestamp = CACurrentMediaTime()
        
        var g_score = [start : 0]
        
        var f_score = [start : (g_score[start]! + heuristic_cost_estimate(start, goal))]
        
        var closeSet = [Configuration]()
        
        var openSet = GlowPriorityQueue()
        openSet.addObject(start, withPriority: f_score[start]!)
        
        var cameFrom = [Configuration : [Configuration : String]]()
        
        while openSet.count > 0 {
            let current = openSet.removeFirstObject() as Configuration
            
            if current == goal {
                dispatch_async(dispatch_get_main_queue()) {
                    self.stepStack = self.pathsDescription(cameFrom, result: current)
                    self.data = current

                    self.coordinateLabel.stringValue = "Done ( \(Int(CACurrentMediaTime() - startTimestamp)) Seconds )"
                    self.render()
                }
                return
            }
            
            closeSet.append(current)
            
            for (index, (direction, neighbor)) in enumerate(current.neighbors) {
                if (find(closeSet, neighbor) != nil) {
                    continue
                }
                
                let tentative_g_score = g_score[current]! + distance_between(current, neighbor)
                
                var flag = false
                if let neighbor_g_score = g_score[neighbor] {
                    if tentative_g_score < neighbor_g_score {
                        flag = true
                    }
                }
                
                if !openSet.containsObject(neighbor) || flag {
                    
                    cameFrom[neighbor] = [current : direction]
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.stepStack = self.pathsDescription(cameFrom, result: neighbor)
                        self.data = neighbor
                        
                        self.coordinateLabel.stringValue = "Searching for path... ( \(Int(CACurrentMediaTime() - startTimestamp)) Seconds )"
                        self.render()
                    }
                    
                    g_score[neighbor] = tentative_g_score
                    
                    let cost_estimate = heuristic_cost_estimate(neighbor, goal)
                    
                    f_score[neighbor] = g_score[neighbor]! + cost_estimate
                    
                    if !openSet.containsObject(neighbor) {
                        openSet.addObject(neighbor, withPriority: f_score[neighbor]!)
                    }
                }
            }
        }
    }
    
    func pathsDescription(cameFrom: [Configuration : [Configuration : String]], result: Configuration) -> [String] {
        var paths = [String]()
        var query = result
        while (cameFrom[query] != nil) {
            let dict = cameFrom[query]!
            query = dict.keys.first!
            let path = dict.values.first!
            paths.insert(path, atIndex: 0)
        }
        
        return paths
    }
    
    func heuristic_cost_estimate(config1: Configuration, _ config2: Configuration) -> Int {
        return (config1 - config2) + abs(config1.coordinate!.x - config2.coordinate!.x) + abs(config1.coordinate!.y - config2.coordinate!.y)
    }
    
    func distance_between(config1: Configuration, _ config2: Configuration) -> Int {
        return config1 - config2
    }

}

