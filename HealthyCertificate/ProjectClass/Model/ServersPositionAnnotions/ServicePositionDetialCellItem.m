//
//  ServicePositionDetialCellItem.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServicePositionDetialCellItem.h"

@implementation ServicePositionDetialCellItem

- (instancetype)initWithTitle:(NSString *)title detialText:(NSString *)detial
{
    if (self = [super init]) {
        _titleText = title;
        _detialText = detial;
    }
    return self;
}

@end