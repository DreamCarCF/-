//
//  SendHistoryTableViewCell.h
//  CellPhone
//
//  Created by cf on 16/5/6.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendStatusLabel;
-(void)setWithArry:(NSMutableArray *)dataArry andCellindex:(NSIndexPath*)nindex;
@end
