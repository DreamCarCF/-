//
//  SettingSelectView.m
//  CellPhone
//
//  Created by Sam Feng on 16/5/5.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "SettingSelectView.h"

@implementation SettingSelectView

- (IBAction)ChangeSettingValue:(UIButton *)sender {

    
    [_delegate changeSettingValue:_callType selectValue:sender.tag];
}

+(SettingSelectView *)instanceView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SettingSelectView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
