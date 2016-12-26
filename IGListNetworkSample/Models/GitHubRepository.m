//
//  GitHubRepository.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubRepository.h"

@implementation GitHubRepository

#pragma mark - IDictionaryLiteralConvertible

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.name = [dic[@"name"] description];
        self.ID = [dic[@"id"] integerValue];
        self.fullName = [dic[@"full_name"] description];
        self.repoDescription = [dic[@"description"] description];
        
        NSDictionary * ownerDic = (NSDictionary *)dic[@"owner"];
        if ([ownerDic isKindOfClass:[NSDictionary class]]){
            self.owner = [[GitHubUser alloc] initWithDictionary:ownerDic];
        }
        else
            NSAssert(false, @"Owner can't be created");
    }
    return self;
}


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
