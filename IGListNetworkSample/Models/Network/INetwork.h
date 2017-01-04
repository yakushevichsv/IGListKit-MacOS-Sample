//
//  INetwork.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/27/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GitHubRepository;
@class GitHubRateLimit;
typedef dispatch_block_t CancelBlock;

@protocol INetwork <NSObject>

typedef void (^GitHubSearchBlock)(NSArray<GitHubRepository *>* __nullable repositories, NSError* __nullable error);
typedef void (^RateLimitsBlock)(GitHubRateLimit* __nullable searchLimit, GitHubRateLimit*__nullable coreLimit, NSError* __nullable error);

- (BOOL)searchRepositories:(NSString *)query startIndex:(NSInteger)index completion:(GitHubSearchBlock)completion cancel:(CancelBlock)cancel;
- (BOOL)cancelCurrentActiveSearch;

@property (nonatomic, strong, readonly) NSURL *baseURL;

- (void)accessRateLimits:(RateLimitsBlock)completion;

@property (nonatomic, copy)  void (^ _Nullable rateLimitBlock)(GitHubRateLimit* __nullable limit);

@end

