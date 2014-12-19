//
//  GlowPriorityQueue.h
//  Glow
//
//  Created by Yan Li on 12/18/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CFComparisonResult(^GlowPriorityQueueCompareBlock)(id, id);

@interface GlowPriorityQueue : NSObject

@property (nonatomic, assign, readonly) NSUInteger count;

+ (instancetype)priorityQueueWithCompareBlock:(GlowPriorityQueueCompareBlock)block;

- (instancetype)initWithCompareBlock:(GlowPriorityQueueCompareBlock)block NS_DESIGNATED_INITIALIZER;

- (void)addObject:(id)object;

- (BOOL)containsObject:(id)object;

- (id)shift;

@end
