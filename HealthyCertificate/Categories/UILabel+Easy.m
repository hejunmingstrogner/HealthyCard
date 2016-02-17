//
//  UILabel+Easy.m
//  NeuSalesMgrSystem
//
//  Created by whrttv.com on 13-2-19.
//  Copyright (c) 2013年 whrttv.com. All rights reserved.
//

#import "UILabel+Easy.h"

@implementation UILabel (Easy)

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *) color
{
    return [UILabel labelWithFont:font textColor:color backgroundColor:[UIColor clearColor]];
}

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *) color backgroundColor:(UIColor *)background
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = background;
    label.font = font;
    label.textColor = color;
    
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [UILabel labelWithText:text font:font
                        textColor:color backgroundColor:[UIColor clearColor]];
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)background
{
    UILabel *label = [UILabel labelWithFont:font textColor:color backgroundColor:background];
    label.text = text;
    [label sizeToFit];
    
    return label;
}

+ (UILabel *)labelWithFrame:(CGRect) frame text:(NSString *)text textAlignment:(NSTextAlignment)alignment
              lineBreakMode:(NSLineBreakMode)mode font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [UILabel labelWithText:text font:font textColor:color];
    label.frame = frame;
    label.numberOfLines = 0;
    label.textAlignment = alignment;
    label.lineBreakMode = mode;
    
    return label;
}

+ (UILabel *)labelWithFrame:(CGRect) frame text:(NSString *)text textAlignment:(NSTextAlignment)alignment
        lineBreakMode:(NSLineBreakMode)mode font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)background
{
    UILabel *label = [UILabel labelWithText:text font:font textColor:color backgroundColor:background];
    label.frame = frame;
    label.numberOfLines = 0;
    label.textAlignment = alignment;
    label.lineBreakMode = mode;
    
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text maxWidth:(CGFloat)width textAlignment:(NSTextAlignment)alignment
             lineBreakMode:(NSLineBreakMode)mode font:(UIFont *)font textColor:(UIColor *)color
{
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:mode];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    return [UILabel labelWithFrame:frame text:text textAlignment:alignment lineBreakMode:mode font:font textColor:color];
}

+ (UILabel *)labelWithText:(NSString *)text maxWidth:(CGFloat)width textAlignment:(NSTextAlignment)alignment
             lineBreakMode:(NSLineBreakMode)mode font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)background
{
    UILabel *label = [UILabel labelWithText:text maxWidth:width textAlignment:alignment
                              lineBreakMode:mode font:font textColor:color];
    label.backgroundColor = background;
    
    return label;
}

@end
