//
//  GitHubSearchRepositoryVC.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MouseClickObserver <NSObject>
- (BOOL)needToHandleClick:(NSPoint)point;
@end

@protocol SearchRestorable<NSObject>
- (BOOL)restoreSearchOnNeed;
@end

@protocol IGitHubSearchRepositoryViewModel;

@interface GitHubSearchRepositoryVC : NSViewController<MouseClickObserver, SearchRestorable>

@property (nonatomic, strong) id<IGitHubSearchRepositoryViewModel> model;

@end

