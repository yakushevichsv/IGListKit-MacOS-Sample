//
//  GitHubSearchRepositoryItem.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchRepositoryItem.h"
#import "GitHubRepository.h"

@interface GitHubSearchRepositoryItem ()<NSCollectionViewElement>

@property (nonatomic, assign) IBOutlet NSTextField *tfName;
@property (nonatomic, assign) IBOutlet NSTextField *tfFullName;
@property (nonatomic, assign) IBOutlet NSTextField *tfDescription;

@end

@implementation GitHubSearchRepositoryItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.tfName.stringValue = @"";
    self.tfFullName.stringValue = @"";
    self.tfDescription.stringValue = @"";
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    GitHubRepository* repo = (GitHubRepository *)representedObject;
    if (![repo isKindOfClass:[GitHubRepository class]]) return;
    self.tfName.stringValue = repo.name;
    self.tfFullName.stringValue = repo.fullName;
    self.tfDescription.stringValue = repo.repoDescription;
}

@end
