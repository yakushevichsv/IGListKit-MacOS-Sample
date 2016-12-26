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

@interface GitHubSearchRepositoryVC()<NSCollectionViewDelegate, NSCollectionViewDataSource>
{
    id<IGitHubSearchRepositoryViewModel> _modelPrivate;
}

typedef NSArray<GitHubRepository *> RepoArray;

@property (nonatomic,strong) RepoArray *repositories;
@property (nonatomic, weak) IBOutlet NSSearchField *sfRepository;
@property (nonatomic, weak) IBOutlet NSButton *btnSearch;
@property (nonatomic) BOOL isSearching;
@property (nonatomic, assign) IBOutlet NSCollectionView * _Nullable  cvRepository;

@end

@implementation GitHubSearchRepositoryVC

- (void)setModel:(id<IGitHubSearchRepositoryViewModel>)model {
    _modelPrivate = model;
    [self configure];
}

- (id<IGitHubSearchRepositoryViewModel>)model {
    return _modelPrivate;
}

- (void)configure {
    if ([self model] != nil && !self.isSearching) {
        __weak typeof(self) wSelf = self;
        self.isSearching = true;
        NSLog(@"Searching Repo...");
        NSString *query = @"Tetris";
        [self.model searchRepositories:query startIndex:0 completion:^(RepoArray *repositories, NSError *error) {
            NSLog(@"Finished Searching Repo is Error %@",error);
            wSelf.isSearching = false;
            if (error == nil && repositories.count != 0) {
                
                NSMutableArray<GitHubRepository *> *mArray = [NSMutableArray new];
                
                if (wSelf.repositories.count)
                    [mArray addObjectsFromArray:wSelf.repositories];
                [mArray addObjectsFromArray:repositories];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    wSelf.repositories = mArray;
                    if (wSelf.isViewLoaded) {
                        wSelf.sfRepository.stringValue = query;
                        [wSelf.cvRepository reloadData];
                    }
                });
            }
            else {
                //TODO: display item...
            }
        } cancel:^{
            wSelf.isSearching = false;
        }];
    }
}

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
    [self configure];
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
    return [self.repositories count];
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    GitHubSearchRepositoryItem * item = [collectionView makeItemWithIdentifier:[[self class] collectionItemCellName]  forIndexPath:indexPath];
    
    //TODO: continue here...
    [item setRepresentedObject:self.repositories[indexPath.item]];
    return item;
}

#pragma mark - NSCollectionViewDelegate


@end

