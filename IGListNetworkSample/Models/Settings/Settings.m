//
//  Settings.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import "Settings.h"
#import "GitHubUser.h"
#import "GitHubRateLimit.h"

static NSString *kUser = @"UserKey";
static NSString *kSearchRateLimit = @"SearchRateLimitKey";

@implementation Settings

- (void)setAuthentificatedUser:(AuthentificatedGitHubUser *)authentificatedUser {
    NSString *token = authentificatedUser.token;
    if (token.length)
        [[NSUserDefaults standardUserDefaults] setObject:token forKey: kUser];
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUser];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (AuthentificatedGitHubUser *)authentificatedUser {
    AuthentificatedGitHubUser * user = [AuthentificatedGitHubUser new];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:kUser];
    user.token = token;
    return user;
}

- (void)setSearchRateLimitFromDic:(NSDictionary *)dic {
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kSearchRateLimit];
}

- (void)setSearchRateLimit:(GitHubRateLimit *)searchRateLimit {
    if (searchRateLimit)
        [self setSearchRateLimitFromDic:[searchRateLimit convertToDictionary]];
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSearchRateLimit];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (GitHubRateLimit *)searchRateLimit {
   NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSearchRateLimit];
    return [[GitHubRateLimit alloc] initWithDictionary:dic];
}

@end
