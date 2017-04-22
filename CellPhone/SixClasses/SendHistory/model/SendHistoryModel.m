//
//  SendHistoryModel.m
//  CellPhone
//
//  Created by cf on 16/5/6.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "SendHistoryModel.h"

@implementation SendHistoryModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.MyArry = [NSMutableArray new];
    }
    return self;
}


-(NSMutableArray*)sendArryWith:(NSMutableArray *)dataArry
{
    if (dataArry) {
        for (NSDictionary *dic in dataArry) {
            SendHistoryModel * model = [SendHistoryModel new];
            model.phonenNmStr = dic[@"phone"];
            model.timeStr = dic[@"createTime"];
            if ((int)dic[@"messageType"] == 1) {
                model.sendStatusStr = [NSString stringWithFormat:@"彩信%@",dic[@"status"]];
            }else
            {
                model.sendStatusStr = [NSString stringWithFormat:@"短信%@",dic[@"status"]];
            }
            model.contentStr = dic[@"title"];
            [self.MyArry addObject:model];
        }
    }
    return self.MyArry;
}
@end
