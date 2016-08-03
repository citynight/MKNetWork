//
//  MKNetWorkAgent.m
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "MKNetWorkAgent.h"
#import <AFNetWorking.h>
#import "MKBaseRequest.h"

@implementation MKNetWorkAgent {
    AFHTTPSessionManager *_manager;///< SessionManager
    NSMutableDictionary<NSNumber *, NSURLSessionDataTask *> *_requestsRecord;///< 请求列表
}

+ (MKNetWorkAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 实例化 AFHTTPSessionManager
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        _manager.securityPolicy.validatesDomainName = NO;
        
        // 实例化 requestsRecord
        _requestsRecord = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)buildRequestUrl:(MKBaseRequest*)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    return detailUrl;
}

- (void)addRequest:(MKBaseRequest *)baseRequest {
    NSLog(@"\n==================================\n\nRequest Start: \n\n "
          @"%@\n\n==================================",
          [baseRequest requestUrl]);
    
    
    MKRequestMethod method = [baseRequest requestMethod];
    NSString *url = [self buildRequestUrl:baseRequest];
    id param = baseRequest.requestArgument;
    
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (baseRequest.requestSerializerType == MKRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (baseRequest.requestSerializerType == MKRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    requestSerializer.timeoutInterval = [baseRequest requestTimeoutInterval];
    requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    NSURLRequest *request = nil;
    switch (method) {
        case MKRequestMethodGet:
            request = [self generateRequestWithUrlString:url Params:param methodName:@"GET" serializer:requestSerializer];
            break;
        case MKRequestMethodPost:
            request = [self generateRequestWithUrlString:url Params:param methodName:@"Post" serializer:requestSerializer];
            break;
        case MKRequestMethodHead:
            request = [self generateRequestWithUrlString:url Params:param methodName:@"Head" serializer:requestSerializer];
            break;
        case MKRequestMethodPut:
            request = [self generateRequestWithUrlString:url Params:param methodName:@"Put" serializer:requestSerializer];
            break;
        case MKRequestMethodDelete:
            request = [self generateRequestWithUrlString:url Params:param methodName:@"Delete" serializer:requestSerializer];
            break;
        case MKRequestMethodPatch:
            request = [self generateRequestWithUrlString:url Params:param methodName:@"Patch" serializer:requestSerializer];
            break;
            
        default:
            request = [self generateRequestWithUrlString:url Params:param methodName:@"POST" serializer:requestSerializer];
            break;
    }
    
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manager
                dataTaskWithRequest:request
                completionHandler:^(NSURLResponse *_Nonnull response,
                                    id _Nullable responseObject,
                                    NSError *_Nullable error) {
                    NSNumber *requestID = @([dataTask taskIdentifier]);
                    [_requestsRecord removeObjectForKey:requestID];
                    NSData *responseData = responseObject;
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    
                    
                    NSString *responseString =
                    [[NSString alloc] initWithData:responseData
                                          encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"responseString:%@",responseString);
                    if (error) {
                        NSLog(@"error: %@",error);
                        
#warning TODO: 失败回掉
                        NSLog(@"这里应该进行失败回掉");
                    } else {
                        // 检查http response是否成立。
#warning TODO: 成功回掉
                        NSLog(@"这里应该进行成功回掉");
                    }
                }];
    // 添加到请求列表
    NSNumber *requestId = @([dataTask taskIdentifier]);
    _requestsRecord[requestId] = dataTask;
    [dataTask resume];
}

- (NSURLRequest *)generateRequestWithUrlString:(NSString *)url Params:(NSDictionary *)requestParams methodName:(NSString *)methodName serializer:(AFHTTPRequestSerializer*)requestSerializer{
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:methodName URLString:url parameters:requestParams error:NULL];
    return request;
}

@end
