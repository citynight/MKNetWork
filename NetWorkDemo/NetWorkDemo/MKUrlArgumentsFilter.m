//
//  MKUrlArgumentsFilter.m
//  NetWorkDemo
//
//  Created by Mekor on 8/3/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "MKUrlArgumentsFilter.h"
#import "MKNetworkPrivate.h"

@implementation MKUrlArgumentsFilter{
    NSDictionary *_arguments;
}

+(MKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
     return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(MKBaseRequest *)request {
    return [MKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}
@end
