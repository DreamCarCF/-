//
//  SendHistoryTableViewCell.m
//  CellPhone
//
//  Created by cf on 16/5/6.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "SendHistoryTableViewCell.h"
#import "SendHistoryModel.h"
@implementation SendHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setWithArry:(NSMutableArray *)dataArry andCellindex:(NSIndexPath *)nindex
{
    SendHistoryModel * model = dataArry[nindex.row];
    _phoneNumberLabel.text = model.phonenNmStr;
    _timeLabel.text = model.timeStr;
    _contentLabel.text = [NSString stringWithFormat:@"内容标题:%@",model.contentStr];
    _sendStatusLabel.text = model.sendStatusStr;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
