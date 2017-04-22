//
//  Person.m
//  LifeTool
//
//  Created by Zzy on 9/2/14.
//  Copyright (c) 2014 Chihya Tsang. All rights reserved.
//

#import "Person.h"
#import <CoreText/CoreText.h>

@interface Person ()<NSCopying>

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *phoneNumber;

@end

@implementation Person

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithFirstName:lastName:phoneNumber: instead." userInfo:nil];
}

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName phoneNumber:(NSString *)phoneNumer
{
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.phoneNumber = phoneNumer;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Person *new = [[Person alloc] initWithFirstName:self.firstName lastName:self.lastName phoneNumber:self.phoneNumber];
    return new;
}

@end
