//
//  GitHubUser.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/24/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>

@protocol IDictionaryLiteralConvertible <NSObject>
- (instancetype _Nonnull)initWithDictionary:(NSDictionary* _Nonnull)dic;
@end

@protocol IDictionaryRepresentable <NSObject>
- (NSDictionary* _Nonnull)convertToDictionary;
@end

@interface GitHubUser : NSObject<IGListDiffable, IDictionaryLiteralConvertible>

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString* _Nonnull login;
@property (nonatomic) NSURL* _Nonnull url;
@property (nonatomic) NSURL* _Nullable imageURL;

@end


@interface AuthentificatedGitHubUser: GitHubUser
@property (nonatomic) NSString * _Nullable token;
@end
