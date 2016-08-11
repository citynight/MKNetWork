//
//  MKChainRequest.h
//  NetWorkDemo
//
//  Created by Mekor on 8/11/16.
//  Copyright © 2016 李小争. All rights reserved.
//  串行

#import <Foundation/Foundation.h>
#import "MKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class MKChainRequest;
@protocol MKChainRequestDelegate <NSObject>

@optional

- (void)chainRequestFinished:(MKChainRequest *)chainRequest;

- (void)chainRequestFailed:(MKChainRequest *)chainRequest failedBaseRequest:(MKBaseRequest*)request;

@end

typedef void (^ChainCallback)(MKChainRequest *chainRequest, MKBaseRequest *baseRequest);

@interface MKChainRequest : NSObject

@property (weak, nonatomic, nullable) id<MKChainRequestDelegate> delegate;

/// start chain request
- (void)start;

/// stop chain request
- (void)stop;

- (void)addRequest:(MKBaseRequest *)request callback:(nullable ChainCallback)callback;

- (NSArray<MKBaseRequest *> *)requestArray;

@end

NS_ASSUME_NONNULL_END