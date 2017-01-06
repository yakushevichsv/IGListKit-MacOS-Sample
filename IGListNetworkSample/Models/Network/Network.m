//
//  Network.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/27/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "Network.h"
#import "GitHubRepository.h"
#import "GitHubRateLimit.h"
#import "GitHubSearchInfo.h"
#import "GitHubSearchError.h"

@interface Network()
@property (nonatomic, strong, readwrite) NSURL *baseURL;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLSessionDataTask *currentTask;
@end

static Network *sNetwork = nil;

@implementation Network

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sNetwork = [[Network alloc] initPrivate];
    });
    return sNetwork;
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        self.baseURL = [NSURL URLWithString:@"https://api.github.com"];
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
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

#pragma mark - INetwork

- (void)accessRateLimits:(RateLimitsBlock)completion {
    [self.manager GET:@"/rate_limit" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSParameterAssert([dic isKindOfClass:[NSDictionary class]]);
        
        NSDictionary *core = (NSDictionary *)[dic valueForKeyPath: @"resources.core"];
        GitHubRateLimit* coreLimit = [[GitHubRateLimit alloc] initWithDictionary:core];
        
        NSDictionary *search = (NSDictionary *)[dic valueForKeyPath: @"resources.search"];
        GitHubRateLimit* searchLimit = [[GitHubRateLimit alloc] initWithDictionary:search];
        
        completion(searchLimit, coreLimit, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, nil, error);
    }];
}

- (BOOL)cancelCurrentActiveSearch {
    BOOL needCancellation = self.currentTask.state == NSURLSessionTaskStateRunning ||
    self.currentTask.state == NSURLSessionTaskStateSuspended;
    if (needCancellation)
        [self.currentTask cancel];
    self.currentTask = nil;
    return needCancellation;
}

- (BOOL)searchRepositories:(NSString *)query startIndex:(NSInteger)index completion:(GitHubSearchBlock)completion cancel:(CancelBlock)cancel {
    
    [self cancelCurrentActiveSearch];
    
    static NSInteger perPage = 30;
    
    NSInteger pageNumber = index/perPage + 1;
    
    NSDictionary *parameters = @{@"q":query,
                                 @"order":@"desc",
                                 @"per_page": @(perPage),
                                 @"page":@(pageNumber)};
    
    __weak typeof(self) wSelf = self;
    self.currentTask =  [self.manager GET:@"/search/repositories" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [wSelf cancelCurrentActiveSearch];
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
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            
            GitHubSearchInfo *info = [[GitHubSearchInfo alloc] initWithDictionary:httpResponse.allHeaderFields];
            
            info.repositories = [resArray copy];
            
            completion(info ,nil);
        }
        else
            completion(nil,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [wSelf cancelCurrentActiveSearch];
        
        NSLog(@"Error %@", [error debugDescription]);
        if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)
            cancel();
        else {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *) error.userInfo[@"com.alamofire.serialization.response.error.response"];
            NSError *cusError = error;
            if (response.statusCode == 403) {
                GitHubRateLimit *limit = [GitHubRateLimit createRateLimitFromGitHubAPIDictionary:response.allHeaderFields];
                GitHubSearchError *gitError = [GitHubSearchError errorWithDomain:cusError.domain code:cusError.code userInfo:cusError.userInfo];
                gitError.rateLimit = limit;
                cusError = gitError;
            }
            completion(nil,cusError);
        }
    }];
    NSParameterAssert(self.currentTask.state == NSURLSessionTaskStateRunning);
    
    return true;
}

@end
