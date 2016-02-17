//
//  UILabel+Easy.h
//  NeuSalesMgrSystem
//
//  Created by whrttv.com on 13-2-19.
//  Copyright (c) 2013年 whrttv.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Easy)

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *) color;
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *) color backgroundColor:(UIColor *)background;

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)background;

+ (UILabel *)labelWithFrame:(CGRect) frame text:(NSString *)text textAlignment:(NSTextAlignment)alignment
              lineBreakMode:(NSLineBreakMode)mode font:(UIFont *)font textColor:(UIColor *)color;
+ (UILabel *)labelWithFrame:(CGRect) frame text:(NSString *)text textAlignment:(NSTextAlignment)alignment
            lineBreakMode:(NSLineBreakMode)mode font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)background;

+ (UILabel *)labelWithText:(NSString *)text maxWidth:(CGFloat)width textAlignment:(NSTextAlignment)alignment
             lineBreakMode:(NSLineBreakMode)mode font:(UIFont *)font textColor:(UIColor *)color;
+ (UILabel *)labelWithText:(NSString *)text maxWidth:(CGFloat)width textAlignment:(NSTextAlignment)alignment
             lineBreakMode:(NSLineBreakMode)mode font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)background;

@end
