//
//  MKChainRequestAgent.h
//  NetWorkDemo
//
//  Created by Mekor on 8/11/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKChainRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKChainRequestAgent : NSObject

+ (MKChainRequestAgent *)sharedInstance;

- (void)addChainRequest:(MKChainRequest *)request;

- (void)removeChainRequest:(MKChainRequest *)request;

@end

NS_ASSUME_NONNULL_END