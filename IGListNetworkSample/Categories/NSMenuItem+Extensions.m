//
//  NSMenuItem+Extensions.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/28/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "NSMenuItem+Extensions.h"

@implementation NSMenuItem (GitHubSearch)

- (NSMenuItem *)showStatusBarMenuItem {
    static NSInteger showStatusBarTag = 38;
    NSMenuItem *viewItem = [self.submenu itemWithTag:showStatusBarTag];
    NSParameterAssert([viewItem.title isEqualToString:@"Show Status Bar"]);
    return viewItem;
}

@end
