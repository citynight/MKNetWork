//
//  MKNetWorkAgent.h
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//  核心网络请求,将来如果替换AFN直接替换这里就好了

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBaseRequest;
@interface MKNetWorkAgent : NSObject

+ (MKNetWorkAgent *)sharedInstance;
/// 添加网络请求
- (void)addRequest:(MKBaseRequest *)baseRequest;
/// 添加网络请求
- (void)addRequest:(MKBaseRequest *)baseRequest WithParams:(nullable id)params;
/// 取消网络请求
- (void)cancelRequest:(NSNumber *)requestID;

@end

NS_ASSUME_NONNULL_END