//
//  IGitHubSearchRepositoryViewModel.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GitHubRepository;

typedef dispatch_block_t CancelBlock;

@protocol IGitHubSearchRepositoryViewModel <NSObject>

typedef void (^GitHubSearchBlock)(NSArray<GitHubRepository *> *repositories, NSError *error);
- (void)searchRepositories:(NSString *)query startIndex:(NSInteger)index completion:(GitHubSearchBlock)completion cancel:(CancelBlock)cancel;
- (void)cancelCurrentActiveSearch;

@end
