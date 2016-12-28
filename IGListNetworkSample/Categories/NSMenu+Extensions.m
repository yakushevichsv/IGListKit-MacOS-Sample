//
//  NSMenu+Extensions.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/28/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "NSMenu+Extensions.h"

@implementation NSMenu(Extensions)

- (NSMenuItem *)viewMenu {
    static NSInteger tag = 35;
    NSMenuItem *viewItem = [self itemWithTag:tag];
    NSParameterAssert([viewItem.title isEqualToString:@"View"]);
    return viewItem;
}
@end
