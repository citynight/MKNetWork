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
    return @"http://www.baidu.com/s";
}

-(MKRequestMethod)requestMethod {
    return MKRequestMethodGet;
}

-(id)requestArgument {
    return @{@"wd":@"微指"};
}
@end
