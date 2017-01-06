//
//  Coordinator.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/26/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "Coordinator.h"
#import "GitHubSearchRepositoryVC.h"
#import "GitHubSearchRepositoryViewModel.h"
#import "InitialWindowsController.h"
#import "InitialWindowsViewModel.h"
#import "GitHubAPI.h"
#import "Network.h"
#import "Settings.h"

@implementation Coordinator

+ (void)defineRootController:(InitialWindowsController *)controller {
    GitHubSearchRepositoryVC *vc = (GitHubSearchRepositoryVC *)controller.contentViewController;
    Network *network = [Network shared];
    GitHubAPI *api = [[GitHubAPI alloc] initWithNetwork: network];
    Settings *settings = [Settings new];
    
    InitialWindowsViewModel *iModel= [[InitialWindowsViewModel alloc] initWithGitHubAPI:api
                                                                  network:network
                                                                 settings:settings];
    GitHubSearchRepositoryViewModel * searchModel =  [[GitHubSearchRepositoryViewModel alloc] initWithNetwork:[Network shared]];
    vc.model = searchModel;
    searchModel.delegate = iModel;
    controller.model = iModel;
}

@end
