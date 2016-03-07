//
//  UILabel+FontColor.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UILabel+FontColor.h"

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

    NSInteger endTextLength = [NSString stringWithFormat:@" %d", count].length;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %d", text, count]];
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
@end
