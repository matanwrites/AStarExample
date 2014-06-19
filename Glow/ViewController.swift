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

class ViewController: NSViewController {
    
    var defaultData: Configuration {
    get {
        return Configuration([
            Row([kBlank, kRed, kBlue, kBlue]),
            Row([kRed, kRed, kBlue, kBlue]),
            Row([kRed, kRed, kBlue, kBlue]),
            Row([kRed, kRed, kBlue, kBlue]),
            ])
    }
    }
    
    var targetData: Configuration {
    get {
        return Configuration([
            Row([kBlank, kBlue, kRed, kBlue]),
            Row([kBlue, kRed, kBlue, kRed]),
            Row([kRed, kBlue, kRed, kBlue]),
            Row([kBlue, kRed, kBlue, kRed]),
            ])
    }
    }
    
    var data: Configuration?
    
    @IBOutlet var cellContainer: NSView
    @IBOutlet var stepLabel: NSTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellContainer.layer = CALayer()
        cellContainer.wantsLayer = true
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            kKeyboardEventNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { (notification: NSNotification!) -> () in
                let keyTag: Int = notification.userInfo[kUserInfoKeyTag] as Int
                self.handleKeyboardEvent(keyTag)
            })
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        data = defaultData
        render()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window.styleMask |= NSFullSizeContentViewWindowMask
        view.window.titlebarAppearsTransparent = true
        view.window.titleVisibility = .Hidden
        view.window.movableByWindowBackground = true
    }
    
    override func viewDidDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewDidDisappear()
    }
    
    func handleKeyboardEvent(keyTag: Int) {
        println("\(keyTag) Tapped.")
        
        switch keyTag {
        case kTagUp:
            if let newData = data!.up() {
                data = newData
            }
        case kTagDown:
            if let newData = data!.down() {
                data = newData
            }
        case kTagLeft:
            if let newData = data!.left() {
                data = newData
            }
        case kTagRight:
            if let newData = data!.right() {
                data = newData
            }
        case kTagReset:
            data = defaultData
        case kTagTarget:
            data = targetData
        default:
            println("Do nothing.")
        }
        
        render()
    }
    
    func render() {
        if let cells = cellContainer.layer.sublayers {
            for cell: CALayer! in cells.copy() {
                cell.removeFromSuperlayer()
            }
        }
        
        let containerWidth = NSWidth(cellContainer.bounds)
        let width = containerWidth / 4
        let cellWidth = width - kSpacing
        
        // stepLabel.stringValue = Brain.activeBrain().steps
        
        let rows = data!.rows.count - 1
        let columns = data!.rows[0].items.count - 1
        
        for x in 0...rows {
            for y in 0...columns {
                let cell = CALayer()
                cell.frame = CGRectMake(CGFloat(x) * width, containerWidth - CGFloat(y + 1) * width, cellWidth, cellWidth)
                
                switch data!.rows[y].items[x] as String {
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
                
                cellContainer.layer.addSublayer(cell)
            }
        }
    }
    
}

