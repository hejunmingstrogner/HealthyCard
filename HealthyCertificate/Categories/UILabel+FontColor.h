//
//  UILabel+FontColor.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FontColor)
// 设置label中最后几个字的颜色不同，且以括号包起来
-(void)setText:(NSString *)text textFont:(UIFont *)font WithEndText:(NSString *)endText endTextColor:(UIColor *)color;

// 设置label最后一个数字颜色不同
- (void) setText:(NSString *)text Font:(UIFont *)font count:(NSInteger)count endColor:(UIColor *)color;

@end
