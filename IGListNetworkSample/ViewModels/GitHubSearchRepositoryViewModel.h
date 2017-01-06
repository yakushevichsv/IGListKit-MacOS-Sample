//
//  GitHubSearchRepositoryViewModel.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGitHubSearchRepositoryViewModel.h"
#import "INetwork.h"

@class GitHubRateLimit;
@protocol GitHubSearchRepositoryDelegate<NSObject>
- (void)didGetSearchLimit:(GitHubRateLimit *)limit;
@end

@interface GitHubSearchRepositoryViewModel : NSObject<IGitHubSearchRepositoryViewModel>
- (instancetype)initWithNetwork:(id<INetwork>)network;
@property (nonatomic, weak) id<GitHubSearchRepositoryDelegate> delegate;
@end
