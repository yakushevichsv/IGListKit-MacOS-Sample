//
//  GitHubSearchInfo.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/5/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchInfo.h"
#import "GitHubRateLimit.h"

@interface GitHubSearchInfo()

@property (nonatomic, readwrite) GitHubRateLimit*  __nonnull rateLimit;
@property (nonatomic, readwrite) NSUInteger lastPage;
@property (nonatomic, readwrite) NSUInteger nextPage;

@end

@implementation GitHubSearchInfo

#pragma mark - IDictionaryLiteralConvertible

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.rateLimit = [GitHubRateLimit createRateLimitFromGitHubAPIDictionary:dic];
        NSString *linkObj = [dic[@"Link"] description];
        NSString * cString = linkObj;
        
        for (NSInteger i = 0 ;i <2 ; i++) {
        
            NSRange sRange = [cString rangeOfString:@"<"];
        
            if (sRange.location == NSNotFound)
                break;
            
            NSUInteger start = NSMaxRange(sRange);
            NSUInteger restCount = cString.length - start;
        
            NSRange fRange = [cString rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(start, restCount)];
            
            if (fRange.location == NSNotFound)
                break;
            
            NSInteger sIndex = sRange.location + 1;
            NSUInteger count = NSMaxRange(fRange) - 1 - sIndex;
            
            NSString *urlStr = [cString substringWithRange:NSMakeRange(sIndex, count)];
            if (!urlStr.length)
                break;
            
            NSURLComponents * components = [[NSURLComponents alloc] initWithString:urlStr];
            for (NSURLQueryItem *item in components.queryItems) {
                if ([item.name isEqualToString:@"page"]) {
                    NSInteger pageNumber = [item.value integerValue];
                    
                    if (self.nextPage == 0)
                        self.nextPage = pageNumber;
                    else if (self.lastPage == 0) 
                        self.lastPage = pageNumber;
                    break;
                }
            }
            
            cString = [cString substringFromIndex:NSMaxRange(fRange)];
        }
        
    }
    return self;
}

#pragma mark - 
- (BOOL)lastSearch {
    return self.nextPage == self.lastPage;
}

@end
