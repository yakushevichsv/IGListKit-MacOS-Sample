//
//  GitHubSearchInfo.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/5/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubUser.h"
@class GitHubRepository, GitHubRateLimit;

@interface GitHubSearchInfo : NSObject<IDictionaryLiteralConvertible>

@property (nonatomic, readwrite) NSArray<GitHubRepository* >* __nullable repositories;
@property (nonatomic, strong, readonly) GitHubRateLimit*  __nonnull rateLimit;
@property (nonatomic, readonly) NSUInteger lastPage;
@property (nonatomic, readonly) NSUInteger nextPage;

@property (nonatomic, readonly) BOOL lastSearch;

@end
