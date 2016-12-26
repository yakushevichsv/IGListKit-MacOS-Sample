//
//  GitHubSearchRepositoryViewModel.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchRepositoryViewModel.h"
#import "GitHubRepository.h"

@implementation GitHubSearchRepositoryViewModel

- (void)cancelCurrentActiveSearch {
    
}

- (void)searchRepositories:(NSString *)query startIndex:(NSInteger)index completion:(GitHubSearchBlock)completion cancel:(CancelBlock)cancel {
    
#ifdef DEBUG
    
    if  ([query isEqualToString:@"Tetris"] && index >= 0 && index<28) {
        
        NSURL* url = [[NSBundle mainBundle]  URLForResource: [query stringByAppendingString:@"1-29"] withExtension:@"json"];
        
        NSData * retData = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingAllowFragments error:&error];
        
        if (error == nil && [dic isKindOfClass:[NSDictionary class]]){
            //dic[@"items"]
            NSInteger tCount = [dic[@"total_count"] integerValue];
            
            
            NSArray *repoArray = (NSArray *)dic[@"items"];
            if ([repoArray isKindOfClass:[NSArray class]]) {
                BOOL isLast = index + 1 + repoArray.count >= tCount;
                NSLog(@"Is Last item %d",isLast);
                
                NSMutableArray<GitHubRepository*> *resArray = [NSMutableArray new];
                
                [repoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    GitHubRepository *repo = [[GitHubRepository alloc] initWithDictionary:(NSDictionary *)obj];
                    [resArray addObject:repo];
                }];
                
                completion([resArray copy],nil);
            }
            else
                completion(nil, nil);
        }
        else {
            NSLog(@"JSON Error %@",error);
            completion(nil,error);
        }
    }
    else {
        cancel();
    }
    
#endif
    
}

@end
