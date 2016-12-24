//
//  GitHubUser.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>

@interface GitHubUser : NSObject<IGListDiffable>

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString* _Nonnull login;
@property (nonatomic) NSURL* _Nonnull url;
@property (nonatomic) NSURL* _Nullable imageURL;

@end

