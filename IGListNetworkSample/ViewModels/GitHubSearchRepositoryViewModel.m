//
//  GitHubSearchRepositoryViewModel.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchRepositoryViewModel.h"
#import "GitHubRepository.h"
#import <AFNetworking/AFNetworking.h>

@interface GitHubSearchRepositoryViewModel()
@property (nonatomic, strong) NSString *sQuery;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLSessionDataTask *currentTask;
@end

@implementation GitHubSearchRepositoryViewModel

- (instancetype)init {
    if (self = [super init]) {
        NSURL *baseURL = [NSURL URLWithString:@"https://api.github.com"];
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        //https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc
        self.manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        dispatch_queue_t queue;
        dispatch_queue_attr_t attr;
        attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0);
        queue = dispatch_queue_create("IGSample.network.completion.queue", attr);
        self.manager.completionQueue = queue;
        //TODO: add support of rate limit....
        /*
         "X-RateLimit-Limit" = 10;
         "X-RateLimit-Remaining" = 0;
         "X-RateLimit-Reset" = 1482843086;
         */
    }
    return self;
}


#pragma mark - IGitHubSearchRepositoryViewModel

- (BOOL)cancelCurrentActiveSearch {
    return [self cancelCurrentActiveSearch:true];
}

- (BOOL)cancelCurrentActiveSearch:(BOOL)erraseQuery {
    BOOL needCancellation = self.currentTask.state == NSURLSessionTaskStateRunning ||
    self.currentTask.state == NSURLSessionTaskStateSuspended;
    if (needCancellation)
        [self.currentTask cancel];
    self.currentTask = nil;
    if (erraseQuery)
        self.sQuery = nil;
    return needCancellation;
}

- (BOOL)searchRepositories:(NSString *)query startIndex:(NSInteger)index completion:(GitHubSearchBlock)completion cancel:(CancelBlock)cancel {
    
    if ([query isEqualToString:self.sQuery] && self.sQuery.length)
        return false;
    
    [self cancelCurrentActiveSearch];
    
    static NSInteger perPage = 30;
    
    NSInteger pageNumber = index/perPage + 1;
 
    NSDictionary *parameters = @{@"q":query,
                                 @"order":@"desc",
                                 @"per_page": @(perPage),
                                 @"page":@(pageNumber)};
    
    __weak typeof(self) wSelf = self;
    self.sQuery = query;
    self.currentTask =  [self.manager GET:@"/search/repositories" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [wSelf cancelCurrentActiveSearch:false];
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"JSON response %@", dic);
        //TODO: use Mapper library....
        
        NSUInteger tCount = dic[@"total_count"] != nil ? [dic[@"total_count"] integerValue] : 0;
        
        
        NSArray *repoArray = (NSArray *)dic[@"items"];
        if ([repoArray isKindOfClass:[NSArray class]]) {
        
            BOOL isLast = tCount < repoArray.count + index;
            NSLog(@"Is last search %d", isLast);
            //BOOL isLast2 = [dic[@"incomplete_results"] boolValue] == false;
            //NSParameterAssert(isLast == isLast2);
            NSMutableArray<GitHubRepository*> *resArray = [NSMutableArray new];
            
            [repoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GitHubRepository *repo = [[GitHubRepository alloc] initWithDictionary:(NSDictionary *)obj];
                [resArray addObject:repo];
            }];
            
            completion([resArray copy],nil);
        }
        else
            completion(nil,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [wSelf cancelCurrentActiveSearch];

        NSLog(@"Error %@", [error debugDescription]);
        if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)
            cancel();
        else
            completion(nil,error);
    }];
    NSParameterAssert(self.currentTask.state == NSURLSessionTaskStateRunning);
    return true;
}

@end
