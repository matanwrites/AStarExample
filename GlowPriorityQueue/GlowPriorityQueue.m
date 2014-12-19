//
//  GlowPriorityQueue.m
//  Glow
//
//  Created by Yan Li on 12/18/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

#import "GlowPriorityQueue.h"


@interface GlowPriorityQueue()

@property (nonatomic, unsafe_unretained) CFBinaryHeapRef bucket;

@end


@implementation GlowPriorityQueue

static GlowPriorityQueueCompareBlock compareBlock = NULL;

static CFComparisonResult CompareCallBack(const void *ptr1, const void *ptr2, void *info) {
    return compareBlock((__bridge id) ptr1, (__bridge id) ptr2);
}


+ (instancetype)priorityQueueWithCompareBlock:(GlowPriorityQueueCompareBlock)block {
    return [[self alloc] initWithCompareBlock:block];
}


- (instancetype)initWithCompareBlock:(GlowPriorityQueueCompareBlock)block {
    if (self = [super init]) {
        compareBlock = [block copy];
        
        CFBinaryHeapCallBacks callBacks = {
            0,
            nil,
            nil,
            nil,
            &CompareCallBack
        };
        
        _bucket = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callBacks, NULL);
    }
    
    return self;
}


- (void)dealloc {
    if (_bucket) {
        CFRelease(_bucket);
        _bucket = nil;
    }
}


- (void)addObject:(id)object {
    CFBinaryHeapAddValue(_bucket, (__bridge_retained const void *) object);
}


- (BOOL)containsObject:(id)object {
    return (BOOL) CFBinaryHeapContainsValue(_bucket, (__bridge const void *) object);
}


- (id)shift {
    id minimum = (__bridge_transfer id) CFBinaryHeapGetMinimum(_bucket);
    CFBinaryHeapRemoveMinimumValue(_bucket);
    return minimum;
}


- (NSUInteger)count {
    return CFBinaryHeapGetCount(_bucket);
}

@end
