//
//  SendHistoryModel.h
//  CellPhone
//
//  Created by cf on 16/5/6.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendHistoryModel : NSObject
@property (nonatomic,copy) NSString * phonenNmStr;
@property (nonatomic,copy) NSString * timeStr;
@property (nonatomic,copy) NSString *contentStr;
@property (nonatomic,copy) NSString * sendStatusStr;
@property (nonatomic,retain) NSMutableArray * MyArry;
-(NSMutableArray *)sendArryWith:(NSMutableArray *)dataArry;
@end
