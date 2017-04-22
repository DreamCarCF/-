//
//  LoginViewController.h
//  CellPhone
//
//  Created by cf on 16/5/3.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (weak, nonatomic) IBOutlet UIButton *quickRegister;
@property (nonatomic,copy) NSString * panduanString;

@end
