//
//  MKBaseRequest.h
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@end
