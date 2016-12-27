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
#import "Network.h"

@implementation Coordinator

+ (void)defineRootController:(NSWindowController *)controller {
    GitHubSearchRepositoryVC *vc = (GitHubSearchRepositoryVC *)controller.contentViewController;
    vc.model =  [[GitHubSearchRepositoryViewModel alloc] initWithNetwork:[Network shared]];
}

@end
