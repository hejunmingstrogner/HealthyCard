//
//  UIView+RoundingCornor.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UIView+RoundingCornor.h"

@implementation UIView (RoundingCornor)

-(void)addRoundingCornor:(UIRectCorner)edge WithCornerRadii:(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.frame byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addBordersToEdge:(UIRectEdge)edge withColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    if (edge & UIRectEdgeTop) {
        UIView *border = [UIView new];
        border.backgroundColor = color;
        [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
        [self addSubview:border];
    }
    
    if (edge & UIRectEdgeLeft) {
        UIView *border = [UIView new];
        border.backgroundColor = color;
        border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
        [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
        [self addSubview:border];
    }
    
    if (edge & UIRectEdgeBottom) {
        UIView *border = [UIView new];
        border.backgroundColor = color;
        [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
        [self addSubview:border];
    }
    
    if (edge & UIRectEdgeRight) {
        UIView *border = [UIView new];
        border.backgroundColor = color;
        [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
        border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
        [self addSubview:border];
    }
}

@end
