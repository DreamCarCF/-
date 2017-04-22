//
//  DIYmsgViewController.m
//  CellPhone
//
//  Created by cf on 16/5/4.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "DIYmsgViewController.h"
#import "CaiXinViewController.h"
#import "SVProgressHUD.h"
@interface DIYmsgViewController ()<UITextViewDelegate>{
    BOOL alreadyEidtText;
}

@end

@implementation DIYmsgViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自定义短信";
    _inputMMSBox.layer.borderColor = [UIColor blueColor].CGColor;
    _inputMMSBox.layer.borderWidth = 0.8f;
    _inputMMSBox.delegate = self;
    
    [_btnSaveInputMMS addTarget:self action:@selector(saveInputMMS) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancelInput addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    
    alreadyEidtText = NO;
    
    NSString* userDefineMMSS = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDefineMMS"];
    if(userDefineMMSS != nil){
        _inputMMSBox.text = userDefineMMSS;
    }
    

//    UITapGestureRecognizer* recognizer;
//    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
//    recognizer.numberOfTapsRequired = 1;
//    [_inputMMSBox addGestureRecognizer:recognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [_inputMMSBox resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(alreadyEidtText == NO){
        textView.text = @"";
        alreadyEidtText = YES;
    }
    return YES;
}



-(void)saveInputMMS{
    [SVProgressHUD showInfoWithStatus:@"已保存"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_inputMMSBox.text forKey:@"userDefineMMS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)goCaiXinVC:(id)sender {
    
    CaiXinViewController * CaiXinVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CaiXinViewController"];
    [self.navigationController pushViewController:CaiXinVC animated:YES];
    
}

-(void)cancelInput{
    NSLog(@"111");
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
