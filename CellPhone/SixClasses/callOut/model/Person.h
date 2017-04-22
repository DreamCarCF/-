//
//  Person.h
//  LifeTool
//
//  Created by Zzy on 9/2/14.
//  Copyright (c) 2014 Chihya Tsang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (copy, readonly, nonatomic) NSString *firstName;
@property (copy, readonly, nonatomic) NSString *lastName;
@property (copy, readonly, nonatomic) NSString *phoneNumber;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName phoneNumber:(NSString *)phoneNumer;

@end
