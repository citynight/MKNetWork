//
//  MKNetworkConfig.h
//  NetWorkDemo
//
//  Created by Mekor on 8/3/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKUrlFilterProtocol <NSObject>
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(MKBaseRequest *)request;
@end

@interface MKNetworkConfig : NSObject

+ (MKNetworkConfig *)sharedInstance;

@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *gameUrl;

@property (strong, nonatomic, readonly) NSArray<id<MKUrlFilterProtocol>> *urlFilters;


- (void)addUrlFilter:(id<MKUrlFilterProtocol>)filter;

@end

NS_ASSUME_NONNULL_END