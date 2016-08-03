//
//  MKUrlArgumentsFilter.h
//  NetWorkDemo
//
//  Created by Mekor on 8/3/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkConfig.h"
#import "MKBaseRequest.h"

/// 给url追加arguments，用于全局参数，比如AppVersion, ApiVersion等
@interface MKUrlArgumentsFilter : NSObject <MKUrlFilterProtocol>

+ (MKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(MKBaseRequest *)request;

@end
