//
//  EventMonitor.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/6/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface EventMonitor : NSObject
- (instancetype)initWithMask:(NSEventMask)mask handler:(NSEvent* (^)(NSEvent*  event))handler;
- (void)stop;
- (void)start;
@end
