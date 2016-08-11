//
//  MKChainRequest.m
//  NetWorkDemo
//
//  Created by Mekor on 8/11/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "MKChainRequest.h"
#import "MKChainRequestAgent.h"


@interface MKChainRequest ()<MKRequestDelegate>

@property (strong, nonatomic) NSMutableArray<MKBaseRequest *> *requestArray;
@property (strong, nonatomic) NSMutableArray<ChainCallback> *requestCallbackArray;
@property (assign, nonatomic) NSUInteger nextRequestIndex;
@property (strong, nonatomic) ChainCallback emptyCallback;

@end


@implementation MKChainRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _emptyCallback = ^(MKChainRequest *chainRequest, MKBaseRequest *baseRequest) {
            // do nothing
        };
    }
    return self;
}

- (void)start {
    if (_nextRequestIndex > 0) {
        NSLog(@"Error! Chain request has already started.");
        return;
    }
    
    if ([_requestArray count] > 0) {
        [self startNextRequest];
        [[MKChainRequestAgent sharedInstance] addChainRequest:self];
    } else {
        NSLog(@"Error! Chain request array is empty.");
    }
}

- (void)stop {
    [self clearRequest];
    [[MKChainRequestAgent sharedInstance] removeChainRequest:self];
}

- (void)addRequest:(MKBaseRequest *)request callback:(ChainCallback)callback {
    [_requestArray addObject:request];
    if (callback != nil) {
        [_requestCallbackArray addObject:callback];
    } else {
        [_requestCallbackArray addObject:_emptyCallback];
    }
}

- (NSArray<MKBaseRequest *> *)requestArray {
    return _requestArray;
}

- (BOOL)startNextRequest {
    if (_nextRequestIndex < [_requestArray count]) {
        MKBaseRequest *request = _requestArray[_nextRequestIndex];
        _nextRequestIndex++;
        request.delegate = self;
        [request start];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Network Request Delegate

- (void)requestFinished:(MKBaseRequest *)request {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    ChainCallback callback = _requestCallbackArray[currentRequestIndex];
    callback(self, request);
    if (![self startNextRequest]) {
        if ([_delegate respondsToSelector:@selector(chainRequestFinished:)]) {
            [_delegate chainRequestFinished:self];
            [[MKChainRequestAgent sharedInstance] removeChainRequest:self];
        }
    }
}

- (void)requestFailed:(MKBaseRequest *)request {
    if ([_delegate respondsToSelector:@selector(chainRequestFailed:failedBaseRequest:)]) {
        [_delegate chainRequestFailed:self failedBaseRequest:request];
        [[MKChainRequestAgent sharedInstance] removeChainRequest:self];
    }
}

- (void)clearRequest {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    if (currentRequestIndex < [_requestArray count]) {
        MKBaseRequest *request = _requestArray[currentRequestIndex];
        [request stop];
    }
    [_requestArray removeAllObjects];
    [_requestCallbackArray removeAllObjects];
}

@end
