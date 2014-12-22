//
//  GlowPriorityQueue.h
//  Glow
//
//  Created by Yan Li on 12/22/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlowPriorityQueue : NSObject

@property (nonatomic, assign, readonly) NSUInteger count;

+ (instancetype)priorityQueue;

- (void)addObject:(id)object withPriority:(NSInteger)priority;

- (id)removeFirstObject;

- (BOOL)containsObject:(id)object;

@end
