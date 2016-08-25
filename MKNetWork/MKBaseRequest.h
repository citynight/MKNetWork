//
//  MKBaseRequest.h
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//  所有的网络接口直接继承自MKBaseRequest就可以了,可重写自己需要的内容

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , MKRequestMethod) {
    MKRequestMethodGet = 0,
    MKRequestMethodPost,
    MKRequestMethodHead,
    MKRequestMethodPut,
    MKRequestMethodDelete,
    MKRequestMethodPatch,
};

typedef NS_ENUM(NSInteger , MKRequestSerializerType) {
    MKRequestSerializerTypeHTTP = 0,
    MKRequestSerializerTypeJSON,
};

@class MKBaseRequest;

/// 回调代理
@protocol MKRequestDelegate <NSObject>

@optional
- (void)requestFinished:(MKBaseRequest *)request;
- (void)requestFailed:(MKBaseRequest *)request;
- (void)clearRequest;
@end


/// 数据源:获得所需要的参数
@protocol MKRequestParamSource <NSObject>
@required
- (NSDictionary *)paramsForRequest:(MKBaseRequest *)request;
@end

@protocol MKRequestPerform <NSObject>


- (void)beforePerformRequestState;
@required
/// success: 判断成功还是失败
- (void)afterPerformResponseState:(BOOL)success;
@end


@interface MKBaseRequest : NSObject

/**
    保存结果
 */
/// requestID
@property (nonatomic, assign) NSNumber* requestID;
@property (nonatomic, strong, nullable) id responseObject;
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;

/**
    调用需要
 */
/// request delegate object
@property (nonatomic, weak, nullable) id<MKRequestDelegate> delegate;
/// request paramSource
@property (nonatomic, weak, nullable) id<MKRequestParamSource> paramSource;
/// request pageEnable
@property (nonatomic, weak, nullable) id<MKRequestPerform> requestPerform;

/// append self to request queue
- (void)start;
- (void)startWithParams:(id)params;

/// remove self from request queue
- (void)stop;

/// 请求的URL
- (NSString *)requestUrl;

/// 请求的BaseURL
- (NSString *)baseUrl;

/// 请求的cdnURL
- (NSString *)cdnUrl;

/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;

/// Http请求的方法
- (MKRequestMethod)requestMethod;

/// 请求的SerializerType
- (MKRequestSerializerType)requestSerializerType;

/// 是否使用cdn的host地址
- (BOOL)useCDN;

@end

NS_ASSUME_NONNULL_END
