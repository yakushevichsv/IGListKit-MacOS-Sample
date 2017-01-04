//
//  Coordinator.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/26/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@class InitialWindowsController;
@interface Coordinator : NSObject

+ (void)defineRootController:(InitialWindowsController * _Nullable)controller;

@end
