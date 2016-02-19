//
//  CustomButton.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)addClickedBlock:(ButtonActionBlock)block
{
    _block = block;
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton *)button
{
    if (_block) {
        _block(button);
    }
}

@end
