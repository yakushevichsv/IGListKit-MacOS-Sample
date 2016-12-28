//
//  GitHubSearchRepositoryVC.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//
#import <ReactiveObjC/ReactiveObjC.h>
#import "GitHubSearchRepositoryVC.h"
#import "GitHubSearchRepositoryItem.h"
#import "IGitHubSearchRepositoryViewModel.h"
#import "StatusBarView.h"
#import "NSMenuItem+Extensions.h"
#import "NSMenu+Extensions.h"

@interface GitHubSearchRepositoryVC()<NSCollectionViewDelegate, NSCollectionViewDataSource,NSMenuDelegate>
@property (nonatomic, weak) IBOutlet NSSearchField *sfRepository;
@property (nonatomic, weak) IBOutlet NSButton *btnSearch;
@property (nonatomic, weak) IBOutlet NSCollectionView *cvRepository;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constrBottomCollectionView;
@property (nonatomic, strong) IBOutlet StatusBarView *statusBarView;
@end

@implementation GitHubSearchRepositoryVC
@synthesize model = _model;

- (void)setModel:(id<IGitHubSearchRepositoryViewModel>)model {
    _model = model;
    [self racSetup];
}

- (void)racSetup {
    
    if (_model == nil || self.isViewLoaded == false) return ;
    
    __weak typeof(self) wSelf = self;
    
    NSParameterAssert(self.model != nil);
    [[self.model.isSearching subscribeOn:[RACScheduler mainThreadScheduler] ]
     subscribeNext:^(id  _Nullable searchingObj) {
         BOOL isSearching = [searchingObj boolValue];
         self.btnSearch.enabled = !isSearching;
         self.statusBarView.piActivityIndicator.hidden = !isSearching;
         if (isSearching)
             [self.statusBarView.piActivityIndicator startAnimation:nil];
         else
             [self.statusBarView.piActivityIndicator stopAnimation:nil];
    }];
    
    
    [[[[[[[self.sfRepository.rac_textSignal doNext:^(NSString * _Nullable x) {
        self.btnSearch.enabled = self.btnSearch.enabled && x.length;
    }] throttle:0.5] distinctUntilChanged] filter:^BOOL(NSString * _Nullable value) {
        return [value length] > 0;
    }]
       flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        return [wSelf.model searchRepositories:value];
    }] subscribeOn:[RACScheduler mainThreadScheduler] ]
     subscribeNext:^(IGListIndexSetResult * result) {
        
         NSLog(@"Results %@", [result debugDescription]);
         
         if (result.hasChanges)
         [wSelf.cvRepository performBatchUpdates:^{
             
             //[wSelf.cvRepository insertItemsAtIndexPaths:result.inserts];
             
             [result.inserts enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                 [wSelf.cvRepository insertItemsAtIndexPaths:[NSMutableSet setWithObject:[NSIndexPath indexPathForItem:idx inSection:0]]];
             }];
             
             //[wSelf.cvRepository deleteItemsAtIndexPaths:result.deletes];
             
             [result.deletes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                 [wSelf.cvRepository deleteItemsAtIndexPaths:[NSMutableSet setWithObject:[NSIndexPath indexPathForItem:idx inSection:0]]];
             }];
             
             //[wSelf.cvRepository reloadItemsAtIndexPaths:result.updates];
             
             [result.updates enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                 [wSelf.cvRepository reloadItemsAtIndexPaths:[NSMutableSet setWithObject:[NSIndexPath indexPathForItem:idx inSection:0]]];
             }];
             
             [result.moves enumerateObjectsUsingBlock:^(IGListMoveIndex * _Nonnull move, NSUInteger idx, BOOL * _Nonnull stop) {
                 [wSelf.cvRepository moveItemAtIndexPath:[NSIndexPath indexPathForItem:move.from inSection:0] toIndexPath:[NSIndexPath indexPathForItem:move.to inSection:0]];
             }];
         } completionHandler:^(BOOL finished) {
             
         }];
         
         
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
}

- (void)setup {
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"GitHubSearchRepositoryItem" bundle:[NSBundle mainBundle]];
    [self.cvRepository registerNib:nib forItemWithIdentifier:[[self class] collectionItemCellName]];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //[self configure];
    [self setup];
    [self racSetup];
    
    [self subscribeForMenu];
    if ([self isBottomBarMarkedInMenu])
        [self displayBottomStatusBar:NO];
    
}

- (void)dealloc {
    [self unsubscribeForMenu];
}

#pragma mark - Bottom(Status) Bar's methods

- (BOOL)changeBottomBarState {
    NSMenuItem * menuItem = [[NSApp mainMenu].viewMenu showStatusBarMenuItem];
    menuItem.state = !menuItem.state;
    return menuItem.state;
}

- (BOOL)isBottomBarMarkedInMenu {
    NSMenuItem * menuItem = [[NSApp mainMenu].viewMenu showStatusBarMenuItem];
    return menuItem.state == 1;
}
- (NSLayoutConstraint *)bottomStatusBarConstraint {
    NSInteger index = [self.view.constraints indexOfObjectPassingTest:^BOOL(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:@"bStatusBarConstr"]) {
            return TRUE;
            *stop = YES;
        }
        return FALSE;
    }];
    
    return index != NSNotFound ? self.view.constraints[index] : nil;
}

- (void)adjustStatusBar {
    if (self.statusBarView.superview == nil) {
        self.statusBarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.statusBarView];
    }
    [self.statusBarView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [self.statusBarView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    CGFloat h = MIN(CGRectGetHeight(self.statusBarView.piActivityIndicator.bounds) + 4, 20);
    [self.statusBarView.heightAnchor constraintEqualToConstant:h].active = true;
    NSLayoutConstraint *constr = [self.statusBarView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:h];
    constr.identifier = @"bStatusBarConstr";
    constr.active = true;
}

- (void)displayBottomStatusBar:(BOOL)animated {
    if ([self bottomStatusBarConstraint] == nil) {
        [self adjustStatusBar];
    }
    
    [self changeBottomStatusBarPosition:true needToDisplay:true];
}

- (void)hideBottomStatusBar:(BOOL)animated {
    
   [self changeBottomStatusBarPosition:true needToDisplay:false];
    
}

- (void)changeBottomStatusBarPosition:(BOOL)animated needToDisplay:(BOOL)display {
    
    [self.view layoutSubtreeIfNeeded];
    
    CGFloat duration = animated ? (display ? 0.3 : 0.25) : 0.0;
    CGFloat yOffset = display ? 0.0 : CGRectGetHeight(self.statusBarView.bounds);
    
    CGFloat yColOffset = display ? CGRectGetHeight(self.statusBarView.bounds) : 0.0;
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
        context.duration = duration; // you can leave this out if the default is acceptable
        context.allowsImplicitAnimation = YES;
        [self bottomStatusBarConstraint].constant = yOffset;
        self.constrBottomCollectionView.constant = yColOffset;
        [self.view layoutSubtreeIfNeeded];
    } completionHandler:nil];
    
}

#pragma mark - Menu Press 
- (void)subscribeForMenu {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuPressed:) name:NSMenuDidSendActionNotification object:nil];
}

- (void)menuPressed:(NSNotification *)aNotification {
    NSLog(@"Notification %@",[[aNotification userInfo] debugDescription]);
    
    NSParameterAssert(aNotification.name == NSMenuDidSendActionNotification);
    
    NSMenuItem * menuItem = [[NSApp mainMenu].viewMenu showStatusBarMenuItem];
    
    if (menuItem == aNotification.userInfo[@"MenuItem"]) {
        if ([self changeBottomBarState])
            [self displayBottomStatusBar:YES];
        else
            [self hideBottomStatusBar:YES];
    }
}
- (void)unsubscribeForMenu {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMenuDidSendActionNotification object:nil];
}

#pragma mark - NSCollectionViewDataSource
+ (NSString *)collectionItemCellName {
    return @"Cell";
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.model numberOfItems];
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    GitHubSearchRepositoryItem * item = [collectionView makeItemWithIdentifier:[[self class] collectionItemCellName]  forIndexPath:indexPath];
    
    //TODO: continue here...
    [item setRepresentedObject:[self.model modelAtIndex:indexPath.item]];
    return item;
}

#pragma mark - NSCollectionViewDelegate


@end
