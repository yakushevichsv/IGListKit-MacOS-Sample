//
//  GitHubSearchError.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/6/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GitHubRateLimit;

@interface GitHubSearchError : NSError
@property (nonatomic, strong) GitHubRateLimit*  __nonnull rateLimit;
@end
