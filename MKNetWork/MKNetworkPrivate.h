//
//  MKNetworkPrivate.h
//  NetWorkDemo
//
//  Created by Mekor on 8/5/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKNetworkPrivate : NSObject
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;
@end
