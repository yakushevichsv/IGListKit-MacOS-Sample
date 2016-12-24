//
//  GitHubSearchRepositoryItem.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "GitHubSearchRepositoryItem.h"

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

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    NSDictionary * dic = (NSDictionary *)representedObject;
    if (![dic isKindOfClass:[NSDictionary class]]) return;
    self.tfName.stringValue = dic[@"name"];
}

@end
