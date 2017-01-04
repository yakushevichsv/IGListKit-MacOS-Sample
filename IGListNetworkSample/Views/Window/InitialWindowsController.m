//
//  InitialWindowsController.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/30/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "InitialWindowsController.h"
#import <AFNetworking/AFNetworking.h>
#import "GitHubRateLimit.h"

@interface InitialWindowsController ()<NSToolbarDelegate> {
    id<IInitialWindowsViewModel>  _model;
}
@property (nonatomic, strong) NSTimer *remainingTimer;
@property (nonatomic) NSUInteger remainingCount;

@end

static NSString* kToolbarIdentifier = @"iglistnetworksample.toolbar.identifier";
static NSString* kConnectionStateIdentifier = @"iglistnetworksample.toolbar.connection.state.identifier";
static NSString* kAuthUserIdentifier = @"iglistnetworksample.toolbar.user.identifier";
static NSString* kAPIStateIdentifier = @"iglistnetworksample.toolbar.api.state.identifier";
static NSString* kVerticalSpaceIdentifier = @"iglistnetworksample.toolbar.vertical.space.identifier";

static NSString *kError = @"error";
static NSString *kWarning = @"warning";

@implementation InitialWindowsController

@synthesize model = _model;

- (void)setModel:(id<IInitialWindowsViewModel>)model {
    if (_model != model) {
        _model = model;
        [self configurePrivate];
    }
}

- (void)configurePrivate {
    __weak typeof(self) wSelf = self;
    [self.model setGitHubReachabilityBlock:^(BOOL available) {
        __strong typeof(self) sSelf = wSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        if (sSelf.isWindowLoaded) {
            [sSelf.window.toolbar.items enumerateObjectsUsingBlock:^(__kindof NSToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.itemIdentifier isEqualToString:kConnectionStateIdentifier]){
                    [sSelf configure:obj withConnectionState:available];
                    *stop = YES;
                }
            }];
        }
        });
    }];
    
    
    [self.window.toolbar.items enumerateObjectsUsingBlock:^(__kindof NSToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.itemIdentifier isEqualToString:kConnectionStateIdentifier]){
            [self configure:obj withConnectionState:self.model.canReachGitHub];
            *stop = YES;
        }
    }];
    
    [self.model setSearchLimitBlock:^(GitHubRateLimit * _Nullable limit) {
        __strong typeof(self) sSelf = wSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [wSelf disposeTimerOnNeed:YES];
        if (!sSelf) return;
        
        if ([limit hasExpired]) {
            sSelf.remainingCount = MAX(0,ceil([[limit resetDate] timeIntervalSinceNow]));
            NSLog(@"Remainig count %lu ",(unsigned long)sSelf.remainingCount);
            sSelf.remainingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:sSelf selector:@selector(timerFired) userInfo:nil repeats:YES];
            [sSelf disposeTimerOnNeed: !sSelf.remainingCount];
        }
        
        [sSelf.window.toolbar.items enumerateObjectsUsingBlock:^(__kindof NSToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.itemIdentifier isEqualToString:kAPIStateIdentifier]){
                [sSelf configure:obj withRateLimit:limit];
                *stop = YES;
            }
        }];
        });
    }];
    
    [self.window.toolbar.items enumerateObjectsUsingBlock:^(__kindof NSToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.itemIdentifier isEqualToString:kAPIStateIdentifier]){
            [self configure:obj withRateLimit:[self.model getSearchRateLimit]];
            *stop = YES;
        }
    }];

}

- (void)timerFired {
    NSLog(@" %s", __FUNCTION__);
    if (self.remainingCount != 0)
        self.remainingCount -= 1;
    [self disposeTimerOnNeed: !self.remainingCount];
    [self.window.toolbar.items enumerateObjectsUsingBlock:^(__kindof NSToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.itemIdentifier isEqualToString:kAPIStateIdentifier]){
            [self configure:obj withRateLimit:[self.model getSearchRateLimit]];
            *stop = YES;
        }
    }];}

- (BOOL)disposeTimerOnNeed:(BOOL)force {
    if (self.remainingTimer && force) {
        [self.remainingTimer invalidate];
        self.remainingTimer = nil;
        return YES;
    }
    return NO;
}

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

#pragma mark - Offline & Online 

- (void)configure:(NSToolbarItem *)item withConnectionState:(BOOL)state {
    item.view.hidden = state;
}

- (void)configure:(NSToolbarItem *)item withRateLimit:(GitHubRateLimit *)limit {
    NSString *imageName;
    if (!limit) {
        imageName = nil;
    }
    else if (![limit hasExpired] || [limit hasPassedTime]) {
        imageName = kWarning;
        //item.image = [NSImage imageNamed:kWarning];
    }
    else
        imageName = kError;
        //item.image = [NSImage imageNamed:kError];
    //item.image = [NSImage imageNamed:];
    item.image = imageName.length != 0 ? [NSImage imageNamed:imageName] : nil;
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
        [self configure:item withConnectionState:self.model.canReachGitHub];
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
        [self configure:item withRateLimit:[self.model getSearchRateLimit]];
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