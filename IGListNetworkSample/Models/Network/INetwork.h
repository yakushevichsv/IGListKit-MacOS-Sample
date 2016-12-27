//
//  INetwork.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/27/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GitHubRepository;
typedef dispatch_block_t CancelBlock;

@protocol INetwork <NSObject>

typedef void (^GitHubSearchBlock)(NSArray<GitHubRepository *> *repositories, NSError *error);
- (BOOL)searchRepositories:(NSString *)query startIndex:(NSInteger)index completion:(GitHubSearchBlock)completion cancel:(CancelBlock)cancel;
- (BOOL)cancelCurrentActiveSearch;

@end

