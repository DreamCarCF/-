//
//  UserLogin.m
//  beloved999
//
//  Created by Sam Feng on 15/8/14.
//  Copyright (c) 2015年 beloved999. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "DemoViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()<UITextFieldDelegate>{
    NSString * QRUrl;
    NSString *onlyUserStr;
    NSString * lockname;
    int  isfirst;
    
    NSUInteger locknum;
}
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证手机号码";
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self config];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)readNSUserDefaults
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    _userName.text = [userdefaults objectForKey:@"userName"];
    _password.text = [userdefaults objectForKey:@"passWord"];
}
-(void)config{
    _userName.delegate = self;
    _password.delegate = self;
    self.loginBtn.layer.masksToBounds = YES;
    
    [self readNSUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString*) uuid {
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
    CFRelease(puuid);
    
    CFRelease(uuidString);
    
    return result;
    
}

- (IBAction)clickLogin:(UIButton *)sender {

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = self.userName.text;
    NSString * passWord = self.password.text;

    if ([userDefaults integerForKey:@"locknum"] == 5&& [self.userName.text isEqualToString:[userDefaults objectForKey:@"lockname"]]) {
        [SVProgressHUD showInfoWithStatus:@"您的帐号已锁定"];
    }else{
    
    if([userName isEqualToString:@""] || [passWord isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"账号、密码不能为空！"];
    }else{
        
        
        if ([userDefaults objectForKey:@"onlyuser"]!=0) {
            NSLog(@"got it");
            isfirst =2;
            onlyUserStr =[userDefaults objectForKey:@"onlyuser"];
        }else{
            isfirst =1;
            onlyUserStr = [self uuid];
            [userDefaults setObject:onlyUserStr forKey:@"onlyuser"];
            
            [userDefaults synchronize];
        }
        NSLog(@"isfirst ===== %d",isfirst);
        
        
        QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_ios_isLogin?phone=%@&pwd=%@&chNum=%@&type=%d",userName,passWord,onlyUserStr,isfirst];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"jsonString === %@",jsonString);
            
            if ([jsonString isEqualToString:@"登陆成功"]) {
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:userName forKey:@"userName"];
                [userDefaults setObject:passWord forKey:@"passWord"];
                [userDefaults synchronize];
                [self requsestStyleOfphone];
                DemoViewController * demoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoViewController"];
                [self.navigationController pushViewController:demoVC animated:YES];
            }else
            {
                locknum ++;
                if (locknum == 5) {
                    lockname = self.userName.text;
                }
                NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setInteger:locknum forKey:@"locknum"];
                [userDefaults setObject:lockname forKey:@"lockname"];
                [userdefaults synchronize];
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if ([_userName.text isEqualToString:[userDefaults objectForKey:@"userName"]]&&
                [_password.text isEqualToString:[userDefaults objectForKey:@"passWord"]]) {
                DemoViewController * demoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoViewController"];
                [self.navigationController pushViewController:demoVC animated:YES];
            }
            NSLog(@"error");
        }];
      

    }
    }
}



#pragma mark--------------登陆成功之后请求模式

- (void)requsestStyleOfphone
{
    
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = self.userName.text;
    NSString * passWord = self.password.text;

QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_query_In_Out?phone=%@&pwd=%@&type=1",userName,passWord];
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
manager.responseSerializer = [AFHTTPResponseSerializer serializer];

[manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
} progress:^(NSProgress * _Nonnull uploadProgress) {
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString === %@",jsonString);
    
    
    NSArray *array = [jsonString componentsSeparatedByString:@","];
    
    [userDefaults setInteger:[array[1] integerValue] forKey:@"calloutValue"];
    [userDefaults setInteger:[array[0] integerValue] forKey:@"callinValue"];
    [userDefaults synchronize];
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"error");
}];

}


#pragma make - ASIhttp delegate



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
}

- (IBAction)passwordReturn:(UITextField *)sender{
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if((![_userName.text isEqualToString:@""]) && (![_password.text isEqualToString:@""])){
        //        _loginBtn.backgroundColor = [UIColor redColor];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
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