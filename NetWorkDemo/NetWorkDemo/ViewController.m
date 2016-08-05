//
//  ViewController.m
//  NetWorkDemo
//
//  Created by Mekor on 8/2/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "ViewController.h"
#import "BDApi.h"

@interface ViewController ()<MKRequestDelegate,MKRequestParamSource>
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (nonatomic, strong)BDApi *api;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (IBAction)loginClick {
    self.api = [[BDApi alloc]init];
    self.api.delegate = self;
    self.api.paramSource = self;
    NSLog(@"time:%@",[NSDate date]);
    [self.api start];
    
}

#pragma mark - MKRequestDelegate
- (void)requestFinished:(MKBaseRequest *)request{
    NSLog(@"成功");
    self.resultLabel.text = [NSString stringWithFormat:@"成功  -->\n%@",request.requestID];
    NSData *responseData = request.responseObject;
    NSString *responseString =
    [[NSString alloc] initWithData:responseData
                          encoding:NSUTF8StringEncoding];
    NSLog(@"====================\n%@",responseString);
}
- (void)requestFailed:(MKBaseRequest *)request{
    NSLog(@"失败");
    self.resultLabel.text = @"失败";
}

#pragma mark - MKRequestParamSource
-(NSDictionary *)paramsForRequest:(MKBaseRequest *)request {
    return @{@"name":@"lxz",@"pwd":@"123"};
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.api stop];
}
@end
