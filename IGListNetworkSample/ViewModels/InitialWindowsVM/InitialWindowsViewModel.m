//
//  InitialWindowsViewModel.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import "InitialWindowsViewModel.h"
#import "GitHubUser.h"
#import "IGitHubAPI.h"
#import "ISettings.h"
#import "INetwork.h"
#import "GitHubRateLimit.h"

@interface InitialWindowsViewModel()
@property (nonatomic, strong) id<IGitHubAPI> gitHubAPI;
@property (nonatomic, strong) id<ISettings> settings;
@property (nonatomic, strong) id<INetwork> network;
@property (nonatomic, strong) GitHubRateLimit *oSearchLimit;
@end

@implementation InitialWindowsViewModel
@synthesize searchLimitBlock = _searchLimitBlock;
@synthesize oSearchLimit = _oSearchLimit;

- (instancetype)initWithGitHubAPI:(id<IGitHubAPI> )api
                          network:(id<INetwork>)network
                         settings:(id<ISettings>)settings
{
    if (self = [super init]){
        self.network = network;
        self.gitHubAPI = api;
        self.settings = settings;
        
        //TODO: create re run loop....
        __weak typeof(self) wSelf = self;
        [network accessRateLimits:^(GitHubRateLimit *searchLimit, GitHubRateLimit *coreLimit, NSError *error) {
            if (error != nil || coreLimit.remaining == 0) {
                NSLog(@"Search %@", searchLimit);
                NSLog(@"Core %@", coreLimit);
                wSelf.oSearchLimit = [wSelf.settings originalSearchRateLimit];
                [wSelf.settings setSearchRateLimit:wSelf.oSearchLimit];
            }
            else if (searchLimit) {
                [wSelf.settings setSearchRateLimit:searchLimit];
                [wSelf.settings setOriginalSearchRateLimit:searchLimit];
                wSelf.oSearchLimit = searchLimit;
            }
        }];
    }
    return self;
}

- (BOOL)canReachGitHub {
    return self.gitHubAPI.canAccessHost;
}

- (void)setGitHubReachabilityBlock:(void (^)(BOOL))block {
    [self.gitHubAPI setReachabilityBlock:block];
}

- (nullable AuthentificatedGitHubUser *)getAuthorizedUser {
    return  nil;
}

- (void)setGitHubAuthorizationBlock:(nullable void (^)( AuthentificatedGitHubUser* _Nonnull  user))block {
}

- (nullable GitHubRateLimit *)getSearchRateLimit {
    return [self.settings searchRateLimit];
}

- (GitHubRateLimit *)getOriginalSearchRateLimit {
    return self.oSearchLimit;
}

#pragma mark - GitHubSearchRepositoryDelegate
- (void)didGetSearchLimit:(GitHubRateLimit *)limit {
    [self.settings setSearchRateLimit:limit];
    self.searchLimitBlock(limit);
}

@end
