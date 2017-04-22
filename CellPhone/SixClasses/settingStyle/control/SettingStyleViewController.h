//
//  SettingStyleViewController.h
//  CellPhone
//
//  Created by cf on 16/5/4.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

@interface SettingStyleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *LabIncoming;

@property (weak, nonatomic) IBOutlet UILabel *LabDialing;

@property (weak, nonatomic) IBOutlet UILabel *callInStatus;

@property (weak, nonatomic) IBOutlet UIButton *callInBtn;

@property (weak, nonatomic) IBOutlet UILabel *callOutStatus;

@property (weak, nonatomic) IBOutlet UIButton *callOutBtn;

@end