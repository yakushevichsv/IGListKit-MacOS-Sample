//
//  StatusBarView.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/28/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusBarView : NSView
@property (nonatomic, weak) IBOutlet NSProgressIndicator * piActivityIndicator;
@end
