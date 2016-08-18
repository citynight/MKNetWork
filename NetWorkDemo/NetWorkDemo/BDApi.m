//
//  BDApi.m
//  NetWorkDemo
//
//  Created by Mekor on 8/3/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "BDApi.h"

@implementation BDApi
-(NSString *)requestUrl {
    return @"geocode/regeo";
}

-(MKRequestMethod)requestMethod {
    return MKRequestMethodGet;
}

-(MKRequestSerializerType)requestSerializerType {
    return MKRequestSerializerTypeHTTP;
}
@end
