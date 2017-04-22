 //
//  selectNumberViewController.m
//  CellPhone
//
//  Created by caofeng on 16/5/29.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "selectNumberViewController.h"
#import "SVProgressHUD.h"
@interface selectNumberViewController ()<UITextFieldDelegate>
{
    NSString * _currentPhone;
    NSString * _msgStr;
    NSString * userName;
    NSString * password;
    NSString * QRUrl;
    NSUInteger  calloutstatus;
    NSDictionary * seleInforDic;
    NSTimer * myTimer;
    int timecount;

}
@property (weak, nonatomic) IBOutlet UITextField *selectTexField;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

@end

@implementation selectNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    timecount = 8;
    // Do any additional setup after loading the view.
    [self.selectTexField becomeFirstResponder];
    seleInforDic = @{@"1":@"用户不存在",@"2":@"客户限制信息不存在",@"3":@"客户过期或已经欠费",@"4":@"通道信息不存在",@"5":@"按键信息不存在",@"6":@"短信发送失败",@"7":@"客户黑名单",@"8":@"短信发送成功",@"9":@"彩信发送失败",@"10":@"彩信发送成功",@"11":@"发送彩信数目今日已达上线，信息没有发送",@"12":@"发送短信数目今日已达上线，信息没有发送",@"13":@"此乃系统黑名单之内",@"14":@"此按键不曾挂信息",@"15":@"按键没有信息",@"16":@"按键为空或不是手机号码",@"17":@"此号码不是手机号码，将不发送"};
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideOrgetKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}
- (void)scrollTimer
{
    if (self.isHandSend) {
        if (timecount ==0) {
            [myTimer invalidate];
            [myTimer setFireDate:[NSDate distantFuture]];
            [SVProgressHUD dismiss];
             [[self.navigationController popViewControllerAnimated:YES].navigationController popViewControllerAnimated:NO];
        }else
        {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%d秒",timecount]];
            timecount --;
        }
        
    }else
    {
    if (timecount ==0) {
        [myTimer invalidate];
        [myTimer setFireDate:[NSDate distantFuture]];
        self.selectTexField.text = @"0";
        [self loadnetinfo];
    }else
    {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%d秒内未选择任何按键,自动发送0按键内容",timecount]];
        timecount --;
    }
    }
}

- (void)hideOrgetKeyBoard
{
    [self.view endEditing:YES];
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)endEditbtn:(id)sender {
    [SVProgressHUD dismiss];
    [myTimer invalidate];
    [myTimer setFireDate:[NSDate distantFuture]];
    [self.view endEditing:YES];
    
    //执行网络请求传输按键信息后返回转盘；
    [self loadnetinfo];
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length >=2)
    {
        
        [SVProgressHUD showInfoWithStatus:@"只能输入0~9的数字"];
        [textField setClearsOnBeginEditing:YES];
        [textField endEditing:YES];
        return NO;
        
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField

{
    NSLog(@"textFieldDidBeginEditing 已经结束编辑");
    //执行网络请求传输按键信息后返回转盘；
    
    
}


-(void)loadnetinfo
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    userName = [userdefaults objectForKey:@"userName"];
    password = [userdefaults objectForKey:@"passWord"];
    calloutstatus = [userdefaults integerForKey:@"calloutValue"];
    if (calloutstatus == 4 && [self.selectTexField.text isEqualToString:@""]) {
        self.selectTexField.text = @"0";
    }else
    {
        
    }
    
    NSLog(@"tell me why ??????\n\n\n\n\n\\n\n");
    QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_send?localTelephone=%@&pwd=%@&talkDuration=%d&connectStatus=2&pressKeyValue=%@&electricType=%d&toSendTelephone=%@",userName,password,_calllength,self.selectTexField.text,2,_phoneNumber];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString === %@",jsonString);
       
         [SVProgressHUD showInfoWithStatus:[seleInforDic objectForKey:[NSString stringWithFormat:@"%@",jsonString]]];
        

       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [SVProgressHUD showWithStatus:@"网络错误"];
    }];
    
    [[self.navigationController popViewControllerAnimated:YES].navigationController popViewControllerAnimated:NO];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
