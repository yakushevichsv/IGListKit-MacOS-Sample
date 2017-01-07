//
//  GItHubAPIStateVC.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/4/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GitHubSearchRepositoryVC.h"

@interface GItHubAPIStateVC : NSViewController<MouseClickObserver>

@property (nonatomic) NSInteger timeLeftToReset;
@property (nonatomic) NSDate *dateToReset;
@property (nonatomic) NSInteger searchTotalLimit;
@property (nonatomic) NSInteger searchLeftLimit;

@end
