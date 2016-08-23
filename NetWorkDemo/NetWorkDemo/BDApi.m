//
//  BDApi.m
//  NetWorkDemo
//
//  Created by Mekor on 8/3/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "BDApi.h"

@implementation BDApi

NSInteger page = 1;

-(void)start {
    NSMutableDictionary *parms = [[self.paramSource paramsForRequest:self] mutableCopy];
    parms[@"page"] = [NSString stringWithFormat:@"%zd",page];
    [self startWithParams:parms];
}

// 允许分页
-(BOOL)paging {
    return YES;
}

-(NSString *)requestUrl {
    return @"geocode/regeo";
}

-(MKRequestMethod)requestMethod {
    return MKRequestMethodGet;
}

-(MKRequestSerializerType)requestSerializerType {
    return MKRequestSerializerTypeHTTP;
}

-(void)afterPerformResponseState:(BOOL)success {
    // 这里还可以根据总数进行判断
    if (success) {
        page = page +1;
    }else{
        page = page -1;
    }
}

@end
