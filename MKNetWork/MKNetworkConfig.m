//
//  MKNetworkConfig.m
//  NetWorkDemo
//
//  Created by Mekor on 8/3/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "MKNetworkConfig.h"
#import <AFNetworking.h>

@implementation MKNetworkConfig {
    NSMutableArray<id<MKUrlFilterProtocol>> *_urlFilters;
}

+ (MKNetworkConfig *)sharedInstance {
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
        _baseUrl = @"";
        _gameUrl = @"";
        _urlFilters = [NSMutableArray array];
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    return self;
}

- (void)addUrlFilter:(id<MKUrlFilterProtocol>)filter {
    [_urlFilters addObject:filter];
}

- (NSArray<id<MKUrlFilterProtocol>> *)urlFilters {
    return [_urlFilters copy];
}

@end
