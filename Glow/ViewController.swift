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
    
    
    @IBOutlet var cellContainer: NSView
    @IBOutlet var stepLabel: NSTextField
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellContainer.layer = CALayer()
        cellContainer.wantsLayer = true
                
        NSNotificationCenter.defaultCenter().addObserverForName(
            kDataChangeNotificationName,
            object: nil,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { (notification: NSNotification!) -> () in
                // FIXME: might be memory leaks here
                self.reloadData()
            })
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func reloadData() {
        if let cells = cellContainer.layer.sublayers {
            for cell: CALayer! in cells.copy() {
                cell.removeFromSuperlayer()
            }
        }
        
        let containerWidth = NSWidth(cellContainer.bounds)
        let width = containerWidth / 4
        let cellWidth = width - kSpacing
        
        let data = Brain.activeBrain().configuration
        stepLabel.stringValue = Brain.activeBrain().steps
        
        let rows = data.count - 1
        let columns = data[0].count - 1
        
        for x in 0...rows {
            for y in 0...columns {
                let cell = CALayer()
                cell.frame = CGRectMake(CGFloat(x) * width, containerWidth - CGFloat(y + 1) * width, cellWidth, cellWidth)
                
                switch data[y][x] as String {
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
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window.styleMask |= NSFullSizeContentViewWindowMask
        view.window.titlebarAppearsTransparent = true
        view.window.titleVisibility = .Hidden
        view.window.movableByWindowBackground = true
    }
    
}

