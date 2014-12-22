//
//  GlowPriorityQueue.m
//  Glow
//
//  Created by Yan Li on 12/22/14.
//  Copyright (c) 2014 eyeplum.com. All rights reserved.
//

#import "GlowPriorityQueue.h"


@implementation GlowPriorityQueue {
    CFBinaryHeapRef _bucket;
    NSMutableDictionary *_memberCache;
}

+ (instancetype)priorityQueue {
    return [[self alloc] init];
}


static CFComparisonResult compareCallBack(const void *ptr1, const void *ptr2, void *info) {
    NSArray *element1 = (__bridge NSArray *)ptr1;
    NSArray *element2 = (__bridge NSArray *)ptr2;
    if ([element1[1] unsignedIntegerValue] > [element2[1] unsignedIntegerValue]) {
        return kCFCompareGreaterThan;
    } else {
        return kCFCompareLessThan;
    }
}


- (instancetype)init {
    if (self = [super init]) {
        _memberCache = [NSMutableDictionary dictionary];
        
        CFBinaryHeapCallBacks callbacks = {
            0, nil, nil, nil, &compareCallBack
        };
        
        _bucket = CFBinaryHeapCreate(NULL, 0, &callbacks, NULL);
    }
    
    return self;
}


- (void)dealloc {
    if (_bucket) {
        CFRelease(_bucket);
        _bucket = nil;
    }
}


- (NSUInteger)count {
    return CFBinaryHeapGetCount(_bucket);
}


- (void)addObject:(id)object withPriority:(NSInteger)priority {
    CFBinaryHeapAddValue(_bucket, (__bridge_retained void *) @[object, @(priority)]);
    _memberCache[@([object hash])] = @(priority);
}


- (id)removeFirstObject {
    id firstObject = ((__bridge_transfer NSArray *) CFBinaryHeapGetMinimum(_bucket))[0];
    CFBinaryHeapRemoveMinimumValue(_bucket);
    [_memberCache removeObjectForKey:@([firstObject hash])];
    return firstObject;
}


- (BOOL)containsObject:(id)object {
    return _memberCache[@([object hash])] != nil;
}

@end
