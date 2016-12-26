//
//  GitHubSearchRepositoryVC.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol IGitHubSearchRepositoryViewModel;

@interface GitHubSearchRepositoryVC : NSViewController

@property (nonatomic, strong) id<IGitHubSearchRepositoryViewModel> model;

@end

