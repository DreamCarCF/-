//
//  selecCheckTableViewCell.m
//  CellPhone
//
//  Created by cf on 16/5/5.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "selecCheckTableViewCell.h"
#import "selecCheckModel.h"
@interface selecCheckTableViewCell()
{
    NSString * msgcolor;
}
@end
@implementation selecCheckTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setWithArry:(NSMutableArray *)dataArry andCellindex:(NSIndexPath *)nindex
{
    selecCheckModel *model = dataArry[nindex.row];
    _user_name.text = [NSString stringWithFormat:@"用户ID:%@",model.user_name];
    _selecBtn_Value.text =[NSString stringWithFormat:@"按键值:%@",model.selecBtn_Value];
    if ([model.msgAndColorMsg isEqualToString:@"1"]) {
       msgcolor =@"彩信";
    }else{
        msgcolor = @"短信";
    }
    _msgAndColorMsgLabel.text = msgcolor;
    
    _contentTitleLabel.text = [NSString stringWithFormat:@"内容标题: %@",model.contentTitle];
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
