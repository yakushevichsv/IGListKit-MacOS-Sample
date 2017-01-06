//
//  GitHubRateLimit.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubRateLimit.h"

static NSString *kLimit = @"limit";
static NSString *kRemaining = @"remaining";
static NSString *kReset = @"reset";

@interface GitHubRateLimit()

@property (nonatomic, readwrite) NSInteger limit;
@property (nonatomic, readwrite) NSInteger remaining;
@property (nonatomic, readwrite) NSDate *resetDate;
@property (nonatomic, readwrite) NSInteger resetDiff;
@end

@implementation GitHubRateLimit

#pragma mark - IDictionaryLiteralConvertible
- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.limit = [dic[kLimit] integerValue];
        self.remaining = [dic[kRemaining] integerValue];
        NSTimeInterval interval = [dic[kReset] isKindOfClass:[NSNumber class]] ? [dic[kReset] doubleValue] : 0;
        self.resetDate = interval != 0 ?  [NSDate dateWithTimeIntervalSince1970: interval]: dic[kReset];
        if (self.resetDate) {
            self.resetDiff = MAX(floor([self.resetDate timeIntervalSinceDate:[NSDate date]]), 0);
        }
    }
    return self;
}

#pragma mark - IDictionaryRepresentable
- (NSDictionary* _Nonnull)convertToDictionary {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{kLimit : @(self.limit),
                                                                                kRemaining : @(self.remaining)}];
    
    if (self.resetDate)
        dic[kReset] = self.resetDate;
    
    return dic;
}

#pragma mark -

- (BOOL)hasExpired {
    return self.remaining == 0;
}

- (BOOL)hasPassedTime {
    return [self.resetDate compare:[NSDate date]] == NSOrderedAscending;
}

- (BOOL)restoreExpiredLimitsOnNeed {
    if ([self hasPassedTime]) {
        self.remaining = self.limit;
        return YES;
    }
    return NO;
}

@end

@implementation GitHubRateLimit (GitHubAPIError)
+ (instancetype)createRateLimitFromGitHubAPIDictionary:(NSDictionary *)dic {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[kLimit] = dic[@"X-RateLimit-Limit"];
    mDic[kRemaining] = dic[@"X-RateLimit-Remaining"];
    
    mDic[kReset] = @([dic[@"X-RateLimit-Reset"] doubleValue]);//timeIntervalSince1970]);
    return [[GitHubRateLimit alloc] initWithDictionary:[mDic copy]];
}
@end

