//
//  GitHubRepository.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubRepository.h"

@implementation GitHubRepository

#pragma mark - IGListDiffable

- (nonnull id<NSObject>)diffIdentifier {
    return @(self.ID);
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    
    if (self == object)
        return YES;
    
    GitHubRepository * sRepository = (GitHubRepository *)object;
    if (![sRepository isKindOfClass:[GitHubRepository class]])
        return NO;
    
    return sRepository.ID == self.ID &&
    [self.name isEqualToString:sRepository.name] &&
    [self.fullName isEqualToString:sRepository.name];
}

@end
