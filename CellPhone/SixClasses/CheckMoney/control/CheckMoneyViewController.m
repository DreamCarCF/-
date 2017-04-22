//
//  CheckMoneyViewController.m
//  CellPhone
//
//  Created by cf on 16/5/4.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "CheckMoneyViewController.h"
#import "AFNetworking.h"
@interface CheckMoneyViewController ()
{
    NSString *QRUrl;
    NSString *userName;
    NSString *password;
      NSString *htmlStr;
}
@property (nonatomic,strong) UIWebView *weView;
@end

@implementation CheckMoneyViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消费明细";
    _balanceLabel.hidden = YES;
    [self readNet];
}

- (UIWebView*)weView
{
    if (!_weView) {
        _weView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        _weView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:_weView];
        
    }
    return _weView;
}

- (void)readNet
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    userName = [userdefaults objectForKey:@"userName"];
    password = [userdefaults objectForKey:@"passWord"];
    
    QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!QueryIOSMessage?phone=%@&pwd=%@",userName,password];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString === %@",jsonString);
        
            [self.weView loadHTMLString:jsonString baseURL:nil];
//        _balanceLabel.text = [NSString stringWithFormat:@"您的余额:%@元",jsonString];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
