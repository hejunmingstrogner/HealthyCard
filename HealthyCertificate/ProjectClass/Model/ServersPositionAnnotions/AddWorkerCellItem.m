//
//  AddWorkerCellItem.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AddWorkerCellItem.h"

@implementation AddWorkerCellItem

- (instancetype)initWithCustomer:(Customer *)customer customerTest:(CustomerTest *)customertest selectFlag:(SelectFlag)flag
{
    if (self = [super init]) {
        _customer = customer;
        _customerTest = customertest;
        _isSelectFlag = flag;
    }
    return self;
}


@end
