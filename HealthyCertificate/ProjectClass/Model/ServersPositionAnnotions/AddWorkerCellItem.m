//
//  AddWorkerCellItem.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AddWorkerCellItem.h"

@implementation AddWorkerCellItem

- (instancetype)initWithCustomer:(Customer *)customer selectFlag:(SelectFlag)flag
{
    if (self = [super init]) {
        _customer = customer;
        _isSelectFlag = flag;
    }
    return self;
}


@end
