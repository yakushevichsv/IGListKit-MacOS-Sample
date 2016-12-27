//
//  GitHubUser.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubUser.h"

@implementation GitHubUser

#pragma mark - IDictionaryLiteralConvertible

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
    self.login = [dic[@"login"] description];
    self.ID = [dic[@"id"] integerValue];
    self.url = [[NSURL alloc] initWithString:[dic[@"url"] description]];
    self.imageURL = [[NSURL alloc] initWithString:[dic[@"avatar_url"] description]];
    }
    return self;
}

#pragma mark - IGListDiffable

- (nonnull id<NSObject>)diffIdentifier {
    return @(self.ID);
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    if (self == object) return YES;
    GitHubUser * sUser = (GitHubUser *)object;
    if (![sUser isKindOfClass:[GitHubUser class]]) return NO;
    
    return sUser.ID == self.ID &&
            [sUser.login isEqualToString:self.login] &&
            [sUser.url isEqualTo:self.url] &&
            [sUser.imageURL isEqualTo:self.imageURL];
}

@end
