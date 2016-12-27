//
//  IGitHubSearchRepositoryViewModel.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INetwork.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <IGListKit/IGListKit.h>

@protocol ICollectionItemsDataSource <NSObject>

- (NSInteger)numberOfItems;
- (GitHubRepository *)modelAtIndex:(NSInteger)index;

@end

@protocol IGitHubSearchRepository <ICollectionItemsDataSource>

- (RACSignal *)searchRepositories:(NSString *)query;
@property (nonatomic,readonly) RACSubject *isSearching;

@end


@protocol IGitHubSearchRepositoryViewModel <ICollectionItemsDataSource, IGitHubSearchRepository>

@end
