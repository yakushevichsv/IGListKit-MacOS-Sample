//
//  InitialWindowsViewModel.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/3/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IInitialWindowsViewModel.h"
#import "GitHubSearchRepositoryViewModel.h"

@protocol IGitHubAPI, INetwork, ISettings;

@interface InitialWindowsViewModel : NSObject<IInitialWindowsViewModel, GitHubSearchRepositoryDelegate>
- (instancetype)initWithGitHubAPI:(id<IGitHubAPI> )api
                          network:(id<INetwork>)network
                         settings:(id<ISettings>)settings;
@end
