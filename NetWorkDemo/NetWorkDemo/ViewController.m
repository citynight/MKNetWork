//
//  ViewController.m
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "ViewController.h"
#import "BDApi.h"

@interface ViewController ()<MKRequestDelegate>
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BDApi *api = [[BDApi alloc]init];
    api.delegate = self;
    [api start];
}

- (void)requestFinished:(MKBaseRequest *)request{
    NSLog(@"成功");
    self.resultLabel.text = @"成功";
}
- (void)requestFailed:(MKBaseRequest *)request{
    NSLog(@"失败");
    self.resultLabel.text = @"失败";
}


@end
