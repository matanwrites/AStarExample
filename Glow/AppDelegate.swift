//
//  AppDelegate.swift
//  Glow
//
//  Created by Yan Li on 6/9/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

import Cocoa

let kKeyboardEventNotification = "com.eyeplum.keyboard"
let kUserInfoKeyTag = "com.eyeplum.userinfo.tag"

let kTagRight  = 1000
let kTagLeft   = 2000
let kTagUp     = 3000
let kTagDown   = 4000
let kTagReset  = 5000
let kTagTarget = 6000
let kTagUndo   = 10000
let kTagCopy   = 20000

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBAction func keyboardTapped(sender: AnyObject?) {
        if let actionSender: AnyObject = sender {
            if let viewTag: Int = actionSender.tag?() {
                NSNotificationCenter.defaultCenter().postNotificationName(
                    kKeyboardEventNotification,
                    object: self,
                    userInfo: [kUserInfoKeyTag : viewTag])
            }
        }
    }

}

