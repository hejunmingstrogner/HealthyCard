//
//  AddWorkerCellItem.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AddWorkerCellItem.h"

@implementation AddWorkerCellItem

- (instancetype)initWithName:(NSString *)name phone:(NSString *)phone endDate:(NSString *)endDate selectFlag:(SelectFlag)isSelectFlag
{
    if (self = [super init]) {
        _name = name;
        _phone = phone;
        _endDate = endDate;
        _isSelectFlag = isSelectFlag;
    }
    return self;
}

@end
