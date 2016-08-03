//
//  ViewController.m
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "ViewController.h"
#import "BDApi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    AFHTTPRequestSerializer *httpRequestSerializer = [AFHTTPRequestSerializer serializer];
//    httpRequestSerializer.timeoutInterval = 20.0f;
//    httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
//    /// 网络请求头部插入一些内容
//    [httpRequestSerializer setValue:@"测试数据......." forHTTPHeaderField:@"xxxxxxxx"];
//    NSMutableURLRequest *request = [httpRequestSerializer requestWithMethod:@"GET"
//                                                                  URLString:@"http://www.baidu.com"
//                                                                      parameters:nil
//                                                                           error:NULL];
//    [[MKNetWorkAgent sharedInstance] addRequest:request];
    
    BDApi *api = [[BDApi alloc]init];
    [api start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
