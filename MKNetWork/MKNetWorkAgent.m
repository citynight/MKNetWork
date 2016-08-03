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

- (void)addRequest:(MKBaseRequest *)baseRequest {
    NSLog(@"\n==================================\n\nRequest Start: \n\n "
          @"%@\n\n==================================",
          [baseRequest requestUrl]);
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[baseRequest requestUrl]]];
    
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
@end
