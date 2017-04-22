//
//  SettingSelectView.h
//  CellPhone
//
//  Created by Sam Feng on 16/5/5.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CallPhoneType) {
    callIn = 0,//默认从0开始
    CallOut = 1
};



@protocol SettingSelectViewDelegate <NSObject>
-(void)changeSettingValue:(CallPhoneType)callType selectValue:(NSUInteger)value;
@end


@interface SettingSelectView : UIView

+(SettingSelectView *)instanceView;

@property (nonatomic,assign) CallPhoneType callType;
@property (nonatomic,assign) id<SettingSelectViewDelegate> delegate;

@end
