//
//  MKBaseRequest.m
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "MKBaseRequest.h"
#import "MKNetWorkAgent.h"

@implementation MKBaseRequest
-(void)start {
    [[MKNetWorkAgent sharedInstance]addRequest:self];
}

-(void)stop {
    [[MKNetWorkAgent sharedInstance]cancelRequest:self.requestID];
}

- (NSString *)requestUrl {
    return @"";
}

- (NSString *)baseUrl {
    return @"";
}

- (NSString *)gameUrl {
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (MKRequestMethod)requestMethod {
    return MKRequestMethodPost;
}

- (MKRequestSerializerType)requestSerializerType{
    return MKRequestSerializerTypeHTTP;
}

- (BOOL)useGame {
    return NO;
}
@end
