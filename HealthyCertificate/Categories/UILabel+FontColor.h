//
//  UILabel+FontColor.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FontColor)
/**
 *  设置label中最后几个字的颜色不同，且以括号包起来 最后最后几个字用 () 修饰
 *
 *  @param text    文本前体
 *  @param font    文字
 *  @param endText 需要修改的文本
 *  @param color   修改文本的颜色
 */
-(void)setText:(NSString *)text textFont:(UIFont *)font WithEndText:(NSString *)endText endTextColor:(UIColor *)color;

/**
 *  设置label最后一个数字颜色不同
 *
 *  @param text  前边的文本
 *  @param font  文本
 *  @param count 数字
 *  @param color 数字颜色
 */
- (void) setText:(NSString *)text Font:(UIFont *)font count:(NSInteger)count endColor:(UIColor *)color;

/**
 *  设置text endtext无任何修饰的改变文本颜色
 *
 *  @param text     前边文本
 *  @param font     字体
 *  @param endText  需要修改的文本
 *  @param endcolor 修改文本的颜色
 */
- (void) setText:(NSString *)text Font:(UIFont *)font WithEndText:(NSString *)endText endTextColor:(UIColor *)endcolor;

@end
