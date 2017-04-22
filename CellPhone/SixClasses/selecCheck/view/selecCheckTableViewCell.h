//
//  selecCheckTableViewCell.h
//  CellPhone
//
//  Created by cf on 16/5/5.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selecCheckTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *selecBtn_Value;
@property (weak, nonatomic) IBOutlet UILabel *msgAndColorMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;

-(void)setWithArry:(NSMutableArray *)dataArry andCellindex:(NSIndexPath*)nindex;
@end
