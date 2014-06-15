//
//  AppDelegate.swift
//  Glow
//
//  Created by Yan Li on 6/9/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

import Cocoa

let kTagRight = 1000
let kTagLeft  = 2000
let kTagUp    = 3000
let kTagDown  = 4000

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        Brain.activeBrain().printConfiguration()        
    }
    
    @IBAction func keyboardTapped(sender: AnyObject?) {
        if let actionSender: AnyObject = sender {
            if let viewTag: Int = actionSender.tag?() {
                switch viewTag {
                case kTagRight:
                    Brain.activeBrain().R()
                case kTagLeft:
                    Brain.activeBrain().L()
                case kTagUp:
                    Brain.activeBrain().U()
                case kTagDown:
                    Brain.activeBrain().D()
                default:
                    return
                }
            }
        }
    }
    
    @IBAction func resetTapped(sender: AnyObject?) {
        Brain.activeBrain().reset()
    }

}

