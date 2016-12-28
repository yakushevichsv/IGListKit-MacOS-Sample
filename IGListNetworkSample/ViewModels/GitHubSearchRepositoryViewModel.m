//
//  GitHubSearchRepositoryViewModel.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchRepositoryViewModel.h"

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
        //TODO: add support of rate limit....
        /*
         "X-RateLimit-Limit" = 10;
         "X-RateLimit-Remaining" = 0;
         "X-RateLimit-Reset" = 1482843086;
         */
    }
    return self;
}


#pragma mark - IGitHubSearchRepository

- (RACSignal *)searchRepositories:(NSString *)query  {
 
    [self.isSearching sendNext:@(true)];
    RACSubject * signal = [RACSubject subject];
    __weak typeof(self) wSelf = self;
    BOOL scheduled = [self.network searchRepositories:query startIndex:0 completion:^(RepoArray *repositories, NSError *error) {
        NSLog(@"Finished Searching Repo is Error %@",error);
        
        if (error == nil) {
            
            NSMutableArray *mArray = [NSMutableArray new];
            NSArray *tempArray = [wSelf.repositories copy];
            
            /*if (tempArray.count)
                [mArray addObjectsFromArray:tempArray];*/
            [mArray addObjectsFromArray:repositories];
            
            IGListIndexSetResult *result = IGListDiff(tempArray, mArray , IGListDiffEquality);
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.isSearching sendNext:@(false)];
                wSelf.repositories = mArray;
                [signal sendNext:result];
                [signal sendCompleted];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.isSearching sendNext:@(false)];
                [signal sendError:error];
            });
        }
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
