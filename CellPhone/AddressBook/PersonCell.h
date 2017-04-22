//
//  PersonCell.h
//  BM
//
//  Created by yuhuajun on 15/7/13.
//  Copyright (c) 2015年 yuhuajun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
@class CDFInitialsAvatar;
@interface PersonCell : UITableViewCell
{
    UIImageView *_tximg;
    UILabel  *_txtName;
    UILabel  *_nickName;
    UILabel  *_phoneNum;
    UIImageView *itemInBlackList;
}
@property(strong,nonatomic)PersonModel *personDel;

@property(strong,nonatomic)UILabel *youlable;

@property(strong,nonatomic)CDFInitialsAvatar *topAvatar;

-(void)setData:(PersonModel*)personDel;

-(void)setItemInBlackList:(BOOL)isAdded;

@end
