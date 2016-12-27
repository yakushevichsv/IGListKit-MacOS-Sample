//
//  GitHubSearchRepositoryVC.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchRepositoryVC.h"
#import "GitHubSearchRepositoryItem.h"
#import "IGitHubSearchRepositoryViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface GitHubSearchRepositoryVC()<NSCollectionViewDelegate, NSCollectionViewDataSource>
@property (nonatomic, weak) IBOutlet NSSearchField *sfRepository;
@property (nonatomic, weak) IBOutlet NSButton *btnSearch;
@property (nonatomic, assign) IBOutlet NSCollectionView * _Nullable  cvRepository;

@end

@implementation GitHubSearchRepositoryVC
@synthesize model = _model;

- (void)setModel:(id<IGitHubSearchRepositoryViewModel>)model {
    _model = model;
    [self racSetup];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)racSetup {
    
    if (_model == nil || self.isViewLoaded == false) return ;
    
    __weak typeof(self) wSelf = self;
    
    NSParameterAssert(self.model != nil);
    [self.model.isSearching subscribeNext:^(id  _Nullable x) {
        self.btnSearch.enabled = ![x boolValue];
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
    if ([self.cvRepository isKindOfClass:[NSCollectionView class]]) {
        return;
    }
    
    NSCollectionView *cv = [NSCollectionView new];
    cv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:cv];
    self.cvRepository = cv;
    
    NSCollectionViewGridLayout *gridLayout = [NSCollectionViewGridLayout new];
    gridLayout.maximumNumberOfColumns = 1;
    gridLayout.minimumInteritemSpacing = 5;
    gridLayout.minimumLineSpacing = 5;
    gridLayout.minimumItemSize = NSMakeSize(90, 90);
    cv.collectionViewLayout = gridLayout;
    
    [cv.leftAnchor constraintEqualToAnchor:self.sfRepository.leftAnchor].active = YES;
    [cv.rightAnchor constraintEqualToAnchor:self.btnSearch.rightAnchor].active = YES;
    [cv.topAnchor constraintEqualToAnchor:self.sfRepository.bottomAnchor constant:10.0].active = YES;
    [cv.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10.0].active = YES;
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"GitHubSearchRepositoryItem" bundle:[NSBundle mainBundle]];
    
    [self.cvRepository registerNib:nib forItemWithIdentifier:[[self class] collectionItemCellName]];
    
    self.cvRepository.dataSource = self;
    self.cvRepository.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //[self configure];
    [self racSetup];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
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

