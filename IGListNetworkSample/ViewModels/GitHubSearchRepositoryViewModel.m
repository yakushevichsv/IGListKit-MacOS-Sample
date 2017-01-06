//
//  GitHubSearchRepositoryViewModel.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchRepositoryViewModel.h"
#import "GitHubSearchInfo.h"
#import "GitHubSearchError.h"

#import <ReactiveObjC/ReactiveObjC.h>

typedef NSArray<GitHubRepository *> RepoArray;

@interface GitHubSearchRepositoryViewModel()

@property (nonatomic, readwrite) id<INetwork> network;
@property (nonatomic,strong) RepoArray *repositories;
@property (nonatomic,readwrite) RACSubject *isSearching;

@end

@implementation GitHubSearchRepositoryViewModel

- (instancetype)initWithNetwork:(id<INetwork>)network {
    if (self = [super init]) {
        self.network = network;
        self.isSearching = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@(false)];
        self.repositories = [NSArray array];
    }
    return self;
}


#pragma mark - IGitHubSearchRepository

- (RACSignal *)searchRepositories:(NSString *)query  {
 
    [self.isSearching sendNext:@(true)];
    RACSubject * signal = [RACSubject subject];
    __weak typeof(self) wSelf = self;
    BOOL scheduled = [self.network searchRepositories:query startIndex:0 completion:^(GitHubSearchInfo *searchInfo, NSError *error) {
        NSLog(@"Finished Searching Repo is Error %@",error);
        
        GitHubRateLimit *rateLimit;
        
        if (error == nil) {
            
            NSMutableArray *mArray = [NSMutableArray new];
            NSArray *tempArray = [wSelf.repositories copy];
            
            if (searchInfo.repositories.count)
                [mArray addObjectsFromArray:searchInfo.repositories];
            rateLimit = searchInfo.rateLimit;
            IGListIndexSetResult *result = IGListDiff(tempArray, mArray , IGListDiffEquality);
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.isSearching sendNext:@(false)];
                wSelf.repositories = mArray;
                [signal sendNext:result];
                [signal sendCompleted];
            });
        }
        else {
            if ([error isKindOfClass:[GitHubSearchError class]])
                rateLimit = ((GitHubSearchError *)error).rateLimit;
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.isSearching sendNext:@(false)];
                [signal sendError:error];
            });
        }
        
        if (rateLimit)
            [wSelf.delegate didGetSearchLimit:rateLimit];
    } cancel:^{
        [self.isSearching sendNext:@(false)];
        [signal sendCompleted];
    }];
    
    if (!scheduled)
        return [RACSignal empty];
    
    return signal;
}

#pragma mark - ICollectionItemsDataSource

- (NSInteger)numberOfItems {
    return [self.repositories count];
}

- (GitHubRepository *)modelAtIndex:(NSInteger)index {
    return self.repositories[index];
}

@end
