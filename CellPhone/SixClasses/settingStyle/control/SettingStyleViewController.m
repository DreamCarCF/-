//
//  SettingStyleViewController.m
//  CellPhone
//
//  Created by cf on 16/5/4.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "SettingStyleViewController.h"
#import "SettingSelectView.h"


@interface SettingStyleViewController ()<SettingSelectViewDelegate,UIAlertViewDelegate>{
    SettingSelectView *settingSelectView;
    NSDictionary *selectOptionDict;
    NSUInteger  callinstr;
    NSUInteger  calloutstr;
    NSUInteger oldinvlaue;
    NSUInteger oldoutvlaue;
}
@property (nonatomic,assign) NSUInteger callinValue;
@property (nonatomic,assign) NSUInteger calloutValue;
@end

@implementation SettingStyleViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模式设置";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger inStr = [userdefaults integerForKey:@"callinValue"];
    NSUInteger outStr = [userdefaults integerForKey:@"calloutValue"];
    selectOptionDict = @{@"2":@"自动发送",
                         @"4":@"手动默认发送",
                         @"6":@"手动发送",
                         @"8":@"完全不发送",
                         @"10":@"未接电话发送",
                         @"12":@"自定义短信",
                         @"14":@"自定义彩信"
                        };
    if (inStr) {
        oldinvlaue = inStr;
        oldoutvlaue = outStr;
        _callinValue = inStr;
        _calloutValue = outStr;
    }
    
    
    
    settingSelectView = [SettingSelectView instanceView];
    settingSelectView.frame = CGRectMake(0, -ScreenHeight, 0, 0);
    settingSelectView.layer.borderWidth = 0.8;
    settingSelectView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    settingSelectView.delegate = self;
    
    UITapGestureRecognizer* recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    recognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recognizer];
    
    [self changeSettingValue:0 selectValue:_callinValue];
    [self changeSettingValue:1 selectValue:_calloutValue];
}


- (IBAction)changeIncomingMode:(UIButton *)sender {
    
    settingSelectView.callType = callIn;
    [self.view addSubview:settingSelectView];
    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         CGRect frame = CGRectMake(_LabIncoming.frame.origin.x,
                                                   _LabIncoming.frame.origin.y + 30,
                                                   250,
                                                   232);
                         settingSelectView.frame = frame;
                     } completion:^(BOOL finished){
                     }];

}

- (IBAction)chnageCallBackMode:(UIButton *)sender {
    settingSelectView.callType = CallOut;
    [self.view addSubview:settingSelectView];
    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         CGRect frame = CGRectMake(_LabDialing.frame.origin.x,
                                                   _LabDialing.frame.origin.y + 30,
                                                   250,
                                                   232);
                         settingSelectView.frame = frame;
                     } completion:^(BOOL finished){
                     }];
}

- (void)handleTapFrom:(UITapGestureRecognizer*)sender{
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         CGRect frame = CGRectMake(_LabIncoming.frame.origin.x,
                                                   _LabIncoming.frame.origin.y + 30,
                                                   250,
                                                   0);
                         settingSelectView.frame = frame;
                     } completion:^(BOOL finished){
                         [settingSelectView removeFromSuperview];
                     }];
}

-(void)changeSettingValue:(CallPhoneType)callType selectValue:(NSUInteger)value{
    
    
     NSString *key = [NSString stringWithFormat:@"%lu",(unsigned long)value];
    if(callType == callIn){
        _callinValue = value;
        _callInStatus.text = [selectOptionDict objectForKey:key];
        [_callInBtn setTitle:[selectOptionDict objectForKey:key] forState:UIControlStateNormal];
    }else{
        _calloutValue = value;
        _callOutStatus.text = [selectOptionDict objectForKey:key];
        [_callOutBtn setTitle:[selectOptionDict objectForKey:key] forState:UIControlStateNormal];
    }
    [self handleTapFrom:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SaveSettingValue:(UIButton *)sender {
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userdefaults objectForKey:@"userName"];
    NSString *password = [userdefaults objectForKey:@"passWord"];
   
    callinstr = _callinValue;
    calloutstr = _calloutValue;
   
    if (_calloutValue == 12) {
        _calloutValue =8;
    }
    if (_callinValue == 12) {
        _callinValue =8;
    }
    NSString *QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_updateSendModel?phone=%@&pwd=%@&callin=%lu&callout=%lu",
                       userName,
                       password,
                       (unsigned long)_callinValue,
                       (unsigned long)_calloutValue];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([jsonString isEqualToString:@"1"]){
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"修改失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    [userdefaults setInteger:callinstr forKey:@"callinValue"];
    [userdefaults setInteger:calloutstr forKey:@"calloutValue"];
    [userdefaults synchronize];
}

- (IBAction)cancelBtn:(UIButton *)sender {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定取消?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
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
