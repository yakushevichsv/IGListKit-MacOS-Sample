//
//  INetwork.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/27/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GitHubSearchInfo;
@class GitHubSearchError;
@class GitHubRepository;
@class GitHubRateLimit;
typedef dispatch_block_t CancelBlock;

@protocol INetwork <NSObject>

typedef void (^GitHubSearchBlock)(GitHubSearchInfo* __nullable searchInfo, NSError* __nullable error);
typedef void (^RateLimitsBlock)(GitHubRateLimit* __nullable searchLimit, GitHubRateLimit*__nullable coreLimit, NSError* __nullable error);

- (BOOL)searchRepositories:(NSString* __nonnull)query startIndex:(NSInteger)index completion:(GitHubSearchBlock __nonnull)completion cancel:(CancelBlock __nullable)cancel;
- (BOOL)cancelCurrentActiveSearch;

@property (nonatomic, strong, readonly) NSURL* __nonnull baseURL;

- (void)accessRateLimits:(RateLimitsBlock __nonnull)completion;

@end

