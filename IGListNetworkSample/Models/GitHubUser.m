//
//  GitHubUser.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubUser.h"

@implementation GitHubUser

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
            [sUser.url isEqual:self.url];
}

@end
