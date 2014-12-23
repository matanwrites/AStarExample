//
//  PathFinder.swift
//  Glow
//
//  Created by Yan Li on 12/23/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

import Cocoa

typealias PathFinderProgressHandler = (currentPathStack: [String], current: Configuration, finished: Bool) -> Void

class PathFinder {
    
    let progressHandler: PathFinderProgressHandler
    
    init(progressHandler: PathFinderProgressHandler) {
        self.progressHandler = progressHandler
    }
    
    func findPathFrom(start: Configuration, goal: Configuration) {        
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
                    let pathsStack = self.pathsDescription(cameFrom, result: current)
                    self.progressHandler(currentPathStack:pathsStack, current: current, finished: true)
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
                        let pathsStack = self.pathsDescription(cameFrom, result: neighbor)
                        self.progressHandler(currentPathStack:pathsStack, current: neighbor, finished: false)
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
    
    private func pathsDescription(cameFrom: [Configuration : [Configuration : String]], result: Configuration) -> [String] {
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
    
    private func heuristic_cost_estimate(config1: Configuration, _ config2: Configuration) -> Int {
        return distance_between(config1, config2) + (abs(config1.coordinate!.x - config2.coordinate!.x) + abs(config1.coordinate!.y - config2.coordinate!.y))
    }
    
    private func distance_between(config1: Configuration, _ config2: Configuration) -> Int {
        return config1 - config2
    }

    
}
