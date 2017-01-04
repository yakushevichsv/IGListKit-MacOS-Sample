//
//  GitHubAPI.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubAPI.h"
#import <AFNetworking/AFNetworking.h>

@interface GitHubAPI()
@property (nonatomic, strong) id<INetwork> network;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;
@property (nonatomic, copy) void (^block)(BOOL available);
@end

@implementation GitHubAPI

- (instancetype)initWithNetwork:(id<INetwork>)network {
    if (self = [super init]) {
        self.network = network;
        self.reachability = [AFNetworkReachabilityManager managerForDomain:self.network.baseURL.host];
    }
    return  self;
}

- (void)dealloc {
    [self setReachabilityBlock:nil];
    self.reachability = nil;
}

#pragma mark - IGitHubAPI

- (BOOL)canAccessHost {
    return self.reachability.isReachable;
}

- (void)setReachabilityBlock:(nullable void (^)(BOOL available))block {
    
    if (_block != block) {
        if (block != nil && _block == nil)
            [self.reachability startMonitoring];
        else if (_block != nil && block == nil) {
            [self.reachability stopMonitoring];
            [self.reachability setReachabilityStatusChangeBlock:nil];
        }
    }
    
    self.block = block;
    if (block == nil)
        return;
    
    __weak typeof(self) wSelf = self;
    [self.reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (wSelf.block != nil)
            wSelf.block(status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi);
    }];
}


- (nullable AuthentificatedGitHubUser *)getAuthorizationUser {
    return nil;
}

- (void)setGitHubAuthorizationBlock:(nullable void (^)(  AuthentificatedGitHubUser* _Nonnull  user))block {
    
}

@end
