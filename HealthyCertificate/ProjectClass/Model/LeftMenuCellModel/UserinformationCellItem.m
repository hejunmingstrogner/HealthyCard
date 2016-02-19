//
//  UserinformationCellItem.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UserinformationCellItem.h"

@implementation UserinformationCellItem

- (instancetype)initWithiconName:(NSString *)name titleLabelText:(NSString *)title detialLabelText:(NSString *)detial itemtype:(UserinformCellItemType)type
{
    if (self = [super init]) {
        _iconName = name;
        _titleLabelText = title;
        _detialLabelText = detial;
        _itemType = type;
    }
    return self;
}


@end
