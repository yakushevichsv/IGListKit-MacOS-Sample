//
//  GitHubAPI.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGitHubAPI.h"
#import "INetwork.h"

@interface GitHubAPI : NSObject<IGitHubAPI>
- (instancetype)initWithNetwork:(id<INetwork>)network;
@end
