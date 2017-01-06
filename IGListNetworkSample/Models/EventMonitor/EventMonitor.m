//
//  EventMonitor.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/6/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import "EventMonitor.h"

@interface EventMonitor()
@property (nonatomic) id monitor;
@property (nonatomic) NSEventMask mask;
@property (nonatomic) NSEvent* (^handler)(NSEvent* event);
@end

@implementation EventMonitor
@synthesize mask = _mask;
@synthesize monitor = _monitor;
@synthesize handler = _handler;

- (instancetype)initWithMask:(NSEventMask)mask handler:(NSEvent* (^)(NSEvent* event))handler {
    if (self = [super init]) {
        self.mask = mask;
        self.handler = handler;
    }
    return self;
}

- (void)start {
    self.monitor = [NSEvent addLocalMonitorForEventsMatchingMask:self.mask handler:self.handler];
}

- (void)stop {
    if (self.monitor) {
        [NSEvent removeMonitor:self.monitor];
        self.monitor = nil;
    }
}

@end
