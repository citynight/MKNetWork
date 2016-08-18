//
//  MKBaseRequest.m
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "MKBaseRequest.h"
#import "MKNetWorkAgent.h"

@interface MKBaseRequest ()
@property (nonatomic, assign, readwrite) BOOL isLoading;
@end

@implementation MKBaseRequest
-(void)start {
    [[MKNetWorkAgent sharedInstance]addRequest:self];
    self.isLoading = YES;
}

-(void)stop {
    [[MKNetWorkAgent sharedInstance]cancelRequest:self.requestID];
    self.isLoading = NO;
}

- (NSString *)requestUrl {
    return @"";
}

- (NSString *)baseUrl {
    return @"";
}

- (NSString *)cdnUrl {
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

- (BOOL)useCDN {
    return NO;
}

-(void)setResponseObject:(id)responseObject {
    _responseObject = responseObject;
    self.isLoading = NO;
}
@end
