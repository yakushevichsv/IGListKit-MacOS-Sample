//
//  IInitialWindowsViewModel.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AuthentificatedGitHubUser, GitHubRateLimit;

@protocol IInitialWindowsViewModel <NSObject>

- (nullable AuthentificatedGitHubUser *)getAuthorizedUser;
- (void)setGitHubAuthorizationBlock:(nullable void (^)( AuthentificatedGitHubUser* _Nonnull  user))block;

- (BOOL)canReachGitHub;
- (void)setGitHubReachabilityBlock:(nullable void (^)(BOOL available))block;

- (nullable GitHubRateLimit *)getSearchRateLimit;
- (nullable GitHubRateLimit *)getOriginalSearchRateLimit;

@property (nonatomic, copy)   void (^ _Nullable searchLimitBlock)(GitHubRateLimit* _Nonnull  user);//nullable void(^searchLimitBlock)(GitHubRateLimit* _Nonnull limit);

@end
