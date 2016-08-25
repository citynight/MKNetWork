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
#import "MKNetworkConfig.h"

@implementation MKNetWorkAgent {
    AFHTTPSessionManager *_manager;///< SessionManager
    NSMutableDictionary<NSNumber *, NSURLSessionDataTask *> *_requestsRecord;///< 请求列表
    MKNetworkConfig *_config;
    AFNetworkReachabilityStatus _networkStatus;
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
        // 配置初始化
        _config = [MKNetworkConfig sharedInstance];
        
        // 实例化 AFHTTPSessionManager
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        _manager.securityPolicy.validatesDomainName = NO;
        _manager.securityPolicy = _config.securityPolicy;
        // 实例化 requestsRecord
        _requestsRecord = [NSMutableDictionary dictionary];
        _networkStatus = AFNetworkReachabilityStatusUnknown;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    _networkStatus = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
}


#define GenerateRequest(MKMethod) [self generateRequestWithUrlString:url Params:params methodName:MKMethod serializer:requestSerializer]


#pragma mark 添加网络请求
- (void)addRequest:(MKBaseRequest *)baseRequest{
    [self addRequest:baseRequest WithParams:nil];
}

-(void)addRequest:(MKBaseRequest *)baseRequest WithParams:(nullable id)params {
    NSLog(@"\n==================================\n\nRequest Start: \n\n "
          @"%@\n\n==================================",
          [baseRequest requestUrl]);
    
    // 判断网络请求,如果没有网络直接返回失败
    if(_networkStatus == AFNetworkReachabilityStatusNotReachable){
        baseRequest.responseObject = nil;
        baseRequest.requestID = @(0);
        if(baseRequest.delegate != nil){
            [baseRequest.delegate requestFailed:baseRequest];
        }
        return;
    }
    
    MKRequestMethod method = [baseRequest requestMethod];
    NSString *url = [self buildRequestUrl:baseRequest];
    
    if (params == nil) {
        params = [baseRequest.paramSource paramsForRequest:baseRequest];
    }
    
    // ############ 拼接完整链接 start #############
    
    // ############ 拼接完整链接 end #############
    
    
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
            request = GenerateRequest(@"GET");
            break;
        case MKRequestMethodPost:
            request = GenerateRequest(@"POST");
            break;
        case MKRequestMethodHead:
            request = GenerateRequest(@"HEAD");
            break;
        case MKRequestMethodPut:
            request = GenerateRequest(@"PUT");;
            break;
        case MKRequestMethodDelete:
            request = GenerateRequest(@"DELETE");;
            break;
        case MKRequestMethodPatch:
            request = GenerateRequest(@"PATCH");;
            break;
            
        default:
            request = GenerateRequest(@"POST");;
            break;
    }
    
    if ([baseRequest.requestPerform respondsToSelector:@selector(beforePerformRequestState)]) {
        [baseRequest.requestPerform beforePerformRequestState];
    }
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    
    NSLog(@"\n\n############ 完整请求 #################\n%@\n\n",request.URL);
    
    dataTask = [_manager dataTaskWithRequest:request
                           completionHandler:^(NSURLResponse *_Nonnull response,
                                               id _Nullable responseObject,
                                               NSError *_Nullable error)
                {
                NSNumber *requestID = @([dataTask taskIdentifier]);
                baseRequest.requestID = requestID;
                baseRequest.responseObject = responseObject;
                
                [_requestsRecord removeObjectForKey:requestID];
                
                if (error) {
                    if ([baseRequest.requestPerform respondsToSelector:@selector(afterPerformResponseState:)]) {
                        [baseRequest.requestPerform afterPerformResponseState:NO];
                    }
                    if(baseRequest.delegate != nil){
                        [baseRequest.delegate requestFailed:baseRequest];
                    }
                } else {
                    if ([baseRequest.requestPerform respondsToSelector:@selector(afterPerformResponseState:)]) {
                        [baseRequest.requestPerform afterPerformResponseState:YES];
                    }
                    // 检查http response是否成立。
                    if(baseRequest.delegate != nil){
                        [baseRequest.delegate requestFinished:baseRequest];
                    }
                }
                }];
    // 添加到请求列表
    NSNumber *requestId = @([dataTask taskIdentifier]);
    NSLog(@"获取到requestId");
    _requestsRecord[requestId] = dataTask;
    [dataTask resume];
}

#pragma mark 取消网络请求
-(void)cancelRequest:(NSNumber *)requestID {
    NSURLSessionDataTask *requestOperation = _requestsRecord[requestID];
    if (!requestOperation) {
        return;
    }
    [requestOperation cancel];
    [_requestsRecord removeObjectForKey:requestID];
}


#pragma mark - 生成request
- (NSURLRequest *)generateRequestWithUrlString:(NSString *)url Params:(NSDictionary *)requestParams methodName:(NSString *)methodName serializer:(AFHTTPRequestSerializer*)requestSerializer{
    
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:methodName URLString:url parameters:requestParams error:NULL];
    [request setValue:@"123123" forHTTPHeaderField:@"xxxxxxxx"];

    return request;
}

#pragma mark 生成url
- (NSString *)buildRequestUrl:(MKBaseRequest*)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    
    // filter url
    NSArray *filters = [_config urlFilters];
    for (id<MKUrlFilterProtocol> f in filters) {
        detailUrl = [f filterUrl:detailUrl withRequest:request];
    }
    NSString *baseUrl;
    if ([request useCDN]) {
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        } else {
            baseUrl = [_config cdnUrl];
        }
    } else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        } else {
            baseUrl = [_config baseUrl];
        }
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

@end
