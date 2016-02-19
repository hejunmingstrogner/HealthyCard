//
//  UIButton+Easy.h
//  NeuSalesMgrSystem
//
//  Created by whrttv.com on 13-2-19.
//  Copyright (c) 2013年 whrttv.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Easy)

+ (UIButton *)buttonWithNormalImage:(UIImage *)normal highlightImage:(UIImage *)highlightImage;
+ (UIButton *)buttonWithNormalImageName:(NSString *)normal highlightImageName:(NSString *)highlight;
+ (UIButton *)buttonWithLocalizedNormalImageName:(NSString *)normal highlightImageName:(NSString *)highlight;

+ (UIButton *)buttonWithNormalImage:(UIImage *)normal
                     highlightImage:(UIImage *)highlightImage disabledImage:(UIImage *)disabled;
+ (UIButton *)buttonWithNormalImageName:(NSString *)normal
                     highlightImageName:(NSString *)highlight disabledImageName:(NSString *)disabled;
+ (UIButton *)buttonWithLocalizedNormalImageName:(NSString *)normal
                            highlightImageName:(NSString *)highlight disabledImageName:(NSString *)disabled;

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor image:(UIImage *)normal highlightImage:(UIImage *)highlight;
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                    imageName:(NSString *)normal highlightImageName:(NSString *)highlight;
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                    LocalizedImageName:(NSString *)normal highlightImageName:(NSString *)highlight;

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor highlightColor:(UIColor *)hightlight backgroundColor:(UIColor *)backgroundColor;
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor;
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                        shawdowColor:(UIColor *)shadowColor  shawdowOffset:(CGSize)offset
                        image:(UIImage *)normal highlightImage:(UIImage *)highlight;
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                    shawdowColor:(UIColor *)shadowColor shawdowOffset:(CGSize)offset
                    imageName:(NSString *)normal highlightImageName:(NSString *)highlight;
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                    shawdowColor:(UIColor *)shadowColor shawdowOffset:(CGSize)offset
                    LocalizedImageName:(NSString *)normal highlightImageName:(NSString *)highlight;

+ (UIButton *)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)background;
+ (UIButton *)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)background
                        title:(NSString *)title font:(UIFont *)font textColor:(UIColor*) textColor;

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor resizableImage:(UIImage *)normal
      resizableHighlightImage:(UIImage *)highlight titleEdgeInsets:(UIEdgeInsets)insets;

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor resizableImage:(UIImage *)normal
      resizableHighlightImage:(UIImage *)highlight leftInset:(CGFloat)leftInset rightInset:(CGFloat)rightInset;

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor resizableImage:(UIImage *)normal
      resizableHighlightImage:(UIImage *)highlight leftInset:(CGFloat)leftInset rightInset:(CGFloat)rightInset
         minWidthEqualToImage:(BOOL)hasMinWidth;

+ (UIButton *)buttonWithNormalImageName: (NSString *) normalName
                     highlightImageName: (NSString *) highlightName
                                  title: (NSString *) titleText;

+ (UIButton *)buttonWithCustomView:(UIView *)view;

+ (UIButton*) buttonWithTarget:(id)target action:(SEL)sel;

@end
