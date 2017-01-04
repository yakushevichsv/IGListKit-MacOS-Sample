//
//  IGitHubAPI.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AuthentificatedGitHubUser;
@protocol IGitHubAPI <NSObject>

- (BOOL)canAccessHost;
- (void)setReachabilityBlock:(nullable void (^)(BOOL available))block;

- (nullable AuthentificatedGitHubUser *)getAuthorizationUser;
- (void)setGitHubAuthorizationBlock:(nullable void (^)(  AuthentificatedGitHubUser* _Nonnull  user))block;

@end
