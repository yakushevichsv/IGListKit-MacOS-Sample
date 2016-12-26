//
//  GitHubRepository.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/25/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>
#import "GitHubUser.h"


@interface GitHubRepository : NSObject<IGListDiffable, IDictionaryLiteralConvertible>

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString* _Nonnull name;
@property (nonatomic) NSString* _Nonnull  fullName;
@property (nonatomic) NSString* _Nullable repoDescription;
@property (nonatomic) GitHubUser* _Nonnull owner;

@end
