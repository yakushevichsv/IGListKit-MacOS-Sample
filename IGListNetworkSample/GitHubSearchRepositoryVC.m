//
//  GitHubSearchRepositoryVC.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchRepositoryVC.h"
#import "GitHubSearchRepositoryItem.h"

@interface GitHubSearchRepositoryVC()<NSCollectionViewDelegate, NSCollectionViewDataSource>

@property (nonatomic, weak) IBOutlet NSSearchField* sfRepository;
@property (nonatomic, weak) IBOutlet NSButton *btnSearch;

@property (nonatomic, assign) IBOutlet NSCollectionView * _Nullable  cvRepository;

@end

@implementation GitHubSearchRepositoryVC

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    if ([self.cvRepository isKindOfClass:[NSCollectionView class]]) {
        return;
    }
    
    NSCollectionView *cv = [NSCollectionView new];
    cv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:cv];
    self.cvRepository = cv;
    cv.collectionViewLayout = [NSCollectionViewGridLayout new];
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
    return 1;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    GitHubSearchRepositoryItem * item = [collectionView makeItemWithIdentifier:[[self class] collectionItemCellName]  forIndexPath:indexPath];
    //TODO: continue here...
    [item setRepresentedObject:@{@"name": @"Test sample"}];
    return item;
}

#pragma mark - NSCollectionViewDelegate


@end

