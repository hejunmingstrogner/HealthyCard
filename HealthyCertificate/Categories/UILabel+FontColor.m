//
//  UILabel+FontColor.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UILabel+FontColor.h"
#import "UIFont+Custom.h"
@implementation UILabel (FontColor)

-(void)setText:(NSString *)text textFont:(UIFont *)font WithEndText:(NSString *)endText endTextColor:(UIColor *)color
{
    NSInteger Textlength = text.length;
    
    NSInteger endTextLength = [NSString stringWithFormat:@"(%@)", endText].length;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)", text, endText]];
    // 设置最后字体颜色
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(Textlength, endTextLength)];
    // 设置字体
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    self.attributedText = str;
}


- (void)setText:(NSString *)text Font:(UIFont *)font count:(NSInteger)count endColor:(UIColor *)color
{
    NSInteger Textlength = text.length;

    NSInteger endTextLength = [NSString stringWithFormat:@" %ld", (long)count].length;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %ld", text, (long)count]];
    // 设置最后字体颜色
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(Textlength, endTextLength)];
    // 设置字体
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    self.attributedText = str;
}

- (void)setText:(NSString *)text Font:(UIFont *)font WithEndText:(NSString *)endText endTextColor:(UIColor *)endcolor
{
    NSInteger Textlength = text.length;

    NSInteger endTextLength = [NSString stringWithFormat:@"%@", endText].length;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@", text, endText]];
    // 设置最后字体颜色
    [str addAttribute:NSForegroundColorAttributeName value:endcolor range:NSMakeRange(Textlength, endTextLength)];
    // 设置字体
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    self.attributedText = str;
}

-(void)setText:(NSString *)text textFont:(UIFont *)font WithEndText:(NSString *)endText endtextFont:(UIFont *)endtextfont textcolor:(UIColor *)textcolor
{
    NSInteger Textlength = text.length;

    NSInteger endTextLength = [NSString stringWithFormat:@"%@", endText].length;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@", text, endText]];

    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, Textlength)];
    [str addAttribute:NSFontAttributeName value:endtextfont range:NSMakeRange(Textlength, endTextLength)];
    // 设置字体
    [str addAttribute:NSForegroundColorAttributeName value:textcolor range:NSMakeRange(0, str.length)];
    self.attributedText = str;
}
// 设置3个文本的字体
- (void)setText1:(NSString *)text1 text1Color:(UIColor *)color1 text2:(NSString *)text2 text2Color:(UIColor *)color2 text3:(NSString *)text3 text3Color:(UIColor *)color3 size:(NSInteger)fontsize
{
    NSInteger text1length = text1.length;
    NSInteger text2length = text2.length;
    NSInteger text3length = text3.length;

    UIFont *font = [UIFont fontWithType:UIFontOpenSansRegular size:fontsize];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@", text1, text2, text3]];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];

    // 设置文本颜色
    [str addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, text1length)];
    [str addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(text1length, text2length)];
    [str addAttribute:NSForegroundColorAttributeName value:color3 range:NSMakeRange(text1length + text2length, text3length)];
    self.attributedText = str;
}

/**
  * // 设置5个文本的字体
 */
- (void)setText1:(NSString *)text1 text1Color:(UIColor *)color1 text2:(NSString *)text2 text2Color:(UIColor *)color2 text3:(NSString *)text3 text3Color:(UIColor *)color3 text4:(NSString *)text4 text4Color:(UIColor *)color4 text5:(NSString *)text5 text5Color:(UIColor *)color5  size:(NSInteger)fontsize
{
    NSInteger text1length = text1.length;
    NSInteger text2length = text2.length;
    NSInteger text3length = text3.length;
    NSInteger text4length = text4.length;
    NSInteger text5length = text5.length;

    UIFont *font = [UIFont fontWithType:UIFontOpenSansRegular size:fontsize];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@%@%@", text1, text2, text3, text4, text5]];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];

    // 设置文本颜色
    [str addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, text1length)];
    [str addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(text1length, text2length)];
    [str addAttribute:NSForegroundColorAttributeName value:color3 range:NSMakeRange(text1length + text2length, text3length)];
    [str addAttribute:NSForegroundColorAttributeName value:color4 range:NSMakeRange(text1length + text2length + text3length, text4length)];
    [str addAttribute:NSForegroundColorAttributeName value:color5 range:NSMakeRange(text1length + text2length + text3length + text4length, text5length)];
    self.attributedText = str;
}
@end
