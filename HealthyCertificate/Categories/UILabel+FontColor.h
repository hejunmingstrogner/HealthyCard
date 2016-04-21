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

/**
 *  设置文本字体不一样大小
 *
 *  @param text        文本1
 *  @param textfont    文本1字体
 *  @param endText     文本2
 *  @param endtextfont 文本2字体
 *  @param textcolor   文本颜色
 */
- (void) setText:(NSString *)text  textFont:(UIFont *)textfont WithEndText:(NSString *)endText   endtextFont:(UIFont *)endtextfont textcolor:(UIColor *)textcolor;

/**
 *  设置3部分文本颜色
 *
 *  @param text1  文本1
 *  @param color1 文本1颜色
 *  @param text2  文本2
 *  @param color2 文本2颜色
 *  @param text3  文本3
 *  @param color3 文本3颜色
 *  @fontsize  文本字号大小
 */
- (void)setText1:(NSString *)text1 text1Color:(UIColor *)color1 text2:(NSString *)text2 text2Color:(UIColor *)color2 text3:(NSString *)text3 text3Color:(UIColor *)color3 size:(NSInteger)fontsize;

/**
 *  <#Description#>
 *
 *  @param text1  文本1
 *  @param color1 文本1颜色
 *  @param text2  文本2
 *  @param color2 文本2颜色
 *  @param text3  文本3
 *  @param color3 文本3颜色
 *  @param text4    <#text4 description#>
 *  @param color4   <#color4 description#>
 *  @param text5    <#text5 description#>
 *  @param color5   <#color5 description#>
 *  @param fontsize <#fontsize description#>
 */
- (void)setText1:(NSString *)text1 text1Color:(UIColor *)color1 text2:(NSString *)text2 text2Color:(UIColor *)color2 text3:(NSString *)text3 text3Color:(UIColor *)color3 text4:(NSString *)text4 text4Color:(UIColor *)color4 text5:(NSString *)text5 text5Color:(UIColor *)color5  size:(NSInteger)fontsize;
@end
