//
//  InitialWindowsController.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/30/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IInitialWindowsViewModel.h"

@interface InitialWindowsController : NSWindowController

@property (nonatomic, strong) id<IInitialWindowsViewModel> model;

@end
