//
//  MKBaseRequest.h
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger , MKRequestMethod) {
    MKRequestMethodGet = 0,
    MKRequestMethodPost,
    MKRequestMethodHead,
    MKRequestMethodPut,
    MKRequestMethodDelete,
    MKRequestMethodPatch,
};

@interface MKBaseRequest : NSObject

// 让调用者使用的
/**
 requestUrl
 requestMethod
 requestArgument
 */

/// Tag
@property (nonatomic, assign) NSInteger tag;

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

/// 是否使用game的host地址
- (BOOL)useGame;
@end
