//
//  InsetsLabel.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/18.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
