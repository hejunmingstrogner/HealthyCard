//
//  HistoryModel.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel

- (instancetype)initWithCustomer:(CustomerTest *)customer BRContract:(BRContract *)brcontract type:(HISTORY_TYPE)type rows:(NSInteger)rows
{
    if (self = [super init]) {
        _customer = customer;
        _brContract = brcontract;
        _type = type;
        _rows = rows;
    }
    return self;
}


- (instancetype)initWithBrContract:(BRContract *)brcontract names:(BaseTBCellItem *)name address:(BaseTBCellItem *)address time:(BaseTBCellItem *)times type:(HISTORY_TYPE)type rows:(NSInteger)rows
{
    if (self = [super init]) {
        _brContract = brcontract;
        _unitNames = name;
        _checkAddress = address;
        _checktimes = times;
        _type = type;
        _rows = rows;

        _itemArray = @[name, address, times];
    }
    return self;
}

@end
