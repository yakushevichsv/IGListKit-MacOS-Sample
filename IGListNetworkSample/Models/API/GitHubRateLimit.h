//
//  GitHubRateLimit.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubUser.h"

@interface GitHubRateLimit : NSObject<IDictionaryRepresentable, IDictionaryLiteralConvertible>

@property (nonatomic, readonly) NSInteger limit;
@property (nonatomic, readonly) NSInteger remaining;
@property (nonatomic, readonly) NSDate *resetDate;
@property (nonatomic, readonly) NSInteger resetDiff;

- (BOOL)restoreExpiredLimitsOnNeed;
- (BOOL)hasExpired;
- (BOOL)hasPassedTime;

@end

@interface GitHubRateLimit (GitHubAPIError)
+ (instancetype)createRateLimitFromGitHubAPIDictionary:(NSDictionary *)dic;
@end
