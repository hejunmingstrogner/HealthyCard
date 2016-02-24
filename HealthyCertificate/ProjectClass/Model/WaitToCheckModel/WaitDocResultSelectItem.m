//
//  WaitDocResultSelectItem.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "WaitDocResultSelectItem.h"

@implementation WaitDocResultSelectItem

- (instancetype)initWithProjectDetail:(NSString *)detail countAndTime:(NSString *)countTime status:(NSString *)status
{
    if (self = [super init]) {
        _proDetail = detail;
        _countAndTime = countTime;
        _status = status;
    }
    return self;
}

@end
