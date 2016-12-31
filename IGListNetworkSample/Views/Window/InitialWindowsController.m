//
//  InitialWindowsController.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/30/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "InitialWindowsController.h"

@interface InitialWindowsController ()<NSToolbarDelegate>

@end

static NSString* kToolbarIdentifier = @"iglistnetworksample.toolbar.identifier";
static NSString* kConnectionStateIdentifier = @"iglistnetworksample.toolbar.connection.state.identifier";
static NSString* kAuthUserIdentifier = @"iglistnetworksample.toolbar.user.identifier";
static NSString* kAPIStateIdentifier = @"iglistnetworksample.toolbar.api.state.identifier";
static NSString* kVerticalSpaceIdentifier = @"iglistnetworksample.toolbar.vertical.space.identifier";

@implementation InitialWindowsController


- (void)windowDidLoad {
    [super windowDidLoad];
    [self appendToolBar];
}

- (void)appendToolBar {
    if (self.window.toolbar != nil) return;
    
    NSToolbar *toolBar = [[NSToolbar alloc] initWithIdentifier:kToolbarIdentifier];
    toolBar.displayMode = NSToolbarDisplayModeIconAndLabel;
    toolBar.allowsUserCustomization = YES;
    toolBar.delegate = self;
    self.window.toolbar = toolBar;
}

#pragma mark - NSToolbarDelegate

- (NSArray<NSString *> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    
    return @[NSToolbarFlexibleSpaceItemIdentifier,
             kConnectionStateIdentifier,
             kVerticalSpaceIdentifier,
             kAuthUserIdentifier,
             kAPIStateIdentifier];
}

- (NSArray<NSString *> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (nullable NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSLog(@"Flag %hhd", flag);
    NSParameterAssert([toolbar.identifier isEqualToString:kToolbarIdentifier]);
    
    if ([itemIdentifier isEqualToString:NSToolbarFlexibleSpaceItemIdentifier])
        return [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if ([itemIdentifier isEqualToString:kConnectionStateIdentifier]) {
        NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        NSButton *btn = [NSButton buttonWithTitle:@"Offline" target:self action:@selector(connectStatePressed:)];
        [btn setButtonType:NSButtonTypeMomentaryLight];
        item.view = btn;
        item.toolTip = NSLocalizedString(@"Connection state", @"");
        return item;
    }
    
    if ([itemIdentifier isEqualToString:kVerticalSpaceIdentifier]) {
        NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        item.image = [NSImage imageNamed:@"verticalSeparator"];
        return item;
    }
    
    if ([itemIdentifier isEqualToString:kAuthUserIdentifier]) {
        NSToolbarItem *item = [[NSToolbarItem alloc]initWithItemIdentifier:itemIdentifier];
        item.image = [NSImage imageNamed:@"anonym"];
        item.toolTip = NSLocalizedString(@"Authorization status", @"");
        item.label = NSLocalizedString(@"Anonymous", @"");
        return item;
    }
    
    //TODO: configure here some delegate....
    if ([itemIdentifier isEqualToString:kAPIStateIdentifier]) {
        NSToolbarItem *item = [[NSToolbarItem alloc]initWithItemIdentifier:itemIdentifier];
        item.image = [NSImage imageNamed:@"error"];
        item.toolTip = NSLocalizedString(@"GitHub API state", @"");
        item.label = NSLocalizedString(@"GitHub API", @"");
        return item;
    }
    
    return nil;
}

#pragma mark - Actions

- (void)connectStatePressed:(NSButton *)sender {
    
}

@end
