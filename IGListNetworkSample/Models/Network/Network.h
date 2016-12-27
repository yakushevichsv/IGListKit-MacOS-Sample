//
//  Network.h
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/27/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INetwork.h"

@interface Network : NSObject<INetwork>

+ (instancetype)shared;

- (instancetype) __unavailable init;

@end
