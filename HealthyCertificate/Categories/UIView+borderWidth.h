//
//  UIView+borderWidth.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (borderWidth)

- (void)addBordersToEdge:(UIRectEdge)edge withColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

@end
