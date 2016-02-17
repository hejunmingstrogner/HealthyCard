//
//  LeftMenuCellItem.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "LeftMenuCellItem.h"

@implementation LeftMenuCellItem

- (instancetype)initWithiconName:(NSString *)name titleLabelText:(NSString *)title detialLabelText:(NSString *)detial itemtype:(LeftMenuCellItemType)type
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
