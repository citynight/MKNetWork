//
//  MKBaseRequest.h
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

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
@protocol MKRequestDelegate <NSObject>

@optional
- (void)requestFinished:(MKBaseRequest *)request;
- (void)requestFailed:(MKBaseRequest *)request;

@end

@interface MKBaseRequest : NSObject

// 让调用者使用的
/**
 requestUrl
 requestMethod
 requestArgument
 */

/// Tag
@property (nonatomic, assign) NSInteger tag;
/// request delegate object
@property (nonatomic, weak, nullable) id<MKRequestDelegate> delegate;

/// append self to request queue
- (void)start;

/// remove self from request queue
- (void)stop;


/// 请求的URL
- (NSString *)requestUrl;

/// 请求的BaseURL
- (NSString *)baseUrl;

/// 请求的游戏URL
- (NSString *)gameUrl;

/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的参数列表
- (nullable id)requestArgument;

/// Http请求的方法
- (MKRequestMethod)requestMethod;

/// 请求的SerializerType
- (MKRequestSerializerType)requestSerializerType;

/// 是否使用game的host地址
- (BOOL)useGame;

@end

NS_ASSUME_NONNULL_END
