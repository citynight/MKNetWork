//
//  MKChainRequestAgent.m
//  NetWorkDemo
//
//  Created by Mekor on 8/11/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "MKChainRequestAgent.h"

@interface MKChainRequestAgent ()
@property (strong, nonatomic) NSMutableArray<MKChainRequest *> *requestArray;
@end

@implementation MKChainRequestAgent

+ (MKChainRequestAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequest:(MKChainRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeChainRequest:(MKChainRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end
