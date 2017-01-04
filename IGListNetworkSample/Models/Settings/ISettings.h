//
//  ISettings.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AuthentificatedGitHubUser, GitHubRateLimit;

@protocol ISettings <NSObject>

@property (nonatomic, strong) AuthentificatedGitHubUser *authentificatedUser;
@property (nonatomic, strong) GitHubRateLimit * searchRateLimit;

@end
