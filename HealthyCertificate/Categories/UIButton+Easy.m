 //
//  UIButton+Easy.m
//  NeuSalesMgrSystem
//
//  Created by whrttv.com on 13-2-19.
//  Copyright (c) 2013年 whrttv.com. All rights reserved.
//

#import "UIButton+Easy.h"

@implementation UIButton (Easy)

+ (UIButton *)buttonWithNormalImage:(UIImage *)normal highlightImage:(UIImage *)highlightImage
{
    UIButton *button = [[UIButton alloc] init];
    if ( normal )
    {
        [button setBackgroundImage:normal forState:UIControlStateNormal];
    }
    
    if ( highlightImage )
    {
        [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    
    return button;
}

+ (UIButton *)buttonWithNormalImageName:(NSString *)normal highlightImageName:(NSString *)highlight
{
    UIImage *normalImage = nil;
    UIImage *highlightImage = nil;
    if ( normal )
    {
        normalImage = [UIImage imageNamed:normal];
    }
    
    if ( highlight )
    {
        highlightImage = [UIImage imageNamed:highlight];
    }
    
    return [UIButton buttonWithNormalImage:normalImage highlightImage:highlightImage];
}

+ (UIButton *)buttonWithLocalizedNormalImageName:(NSString *)normal highlightImageName:(NSString *)highlight
{
    NSString *normalName = nil;
    NSString *highlightName = nil;
    if ( normal )
    {
        normalName = NSLocalizedString(normal, nil);
    }
    
    if ( highlight )
    {
        highlightName = NSLocalizedString(highlight, nil);
    }

    return [UIButton buttonWithNormalImageName:normalName highlightImageName:highlightName];
}

+ (UIButton *)buttonWithNormalImage:(UIImage *)normal
                     highlightImage:(UIImage *)highlightImage disabledImage:(UIImage *)disabled
{
    UIButton *button = [UIButton buttonWithNormalImage:normal highlightImage:highlightImage];
    if ( disabled )
    {
        [button setBackgroundImage:disabled forState:UIControlStateDisabled];
    }
    
    return button;
}

+ (UIButton *)buttonWithNormalImageName:(NSString *)normal
                     highlightImageName:(NSString *)highlight disabledImageName:(NSString *)disabled
{
    UIImage *normalImage = nil;
    UIImage *highlightImage = nil;
    UIImage *disabledImage = nil;
    if ( normal )
    {
        normalImage = [UIImage imageNamed:normal];
    }
    
    if ( highlight )
    {
        highlightImage = [UIImage imageNamed:highlight];
    }
    
    if ( disabled )
    {
        disabledImage = [UIImage imageNamed:disabled];
    }
    
    return [UIButton buttonWithNormalImage:normalImage highlightImage:highlightImage disabledImage:disabledImage];
}

+ (UIButton *)buttonWithLocalizedNormalImageName:(NSString *)normal
                            highlightImageName:(NSString *)highlight disabledImageName:(NSString *)disalbed
{
    NSString *normalName = nil;
    NSString *highlightName = nil;
    NSString *disabledName = nil;
    if ( normal )
    {
        normalName = NSLocalizedString(normal, nil);
    }
    
    if ( highlight )
    {
        highlightName = NSLocalizedString(highlight, nil);
    }
    
    if ( disalbed )
    {
        disabledName = NSLocalizedString(disalbed, nil);
    }
    
    return [UIButton buttonWithNormalImageName:normalName highlightImageName:highlightName disabledImageName:disabledName];
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor image:(UIImage *)normal highlightImage:(UIImage *)highlight
{
    UIButton *button = [UIButton buttonWithNormalImage:normal highlightImage:highlight];
    
    if ( textColor )
    {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    if ( font )
    {
        button.titleLabel.font = font;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];

    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                    imageName:(NSString *)normal highlightImageName:(NSString *)highlight
{
    UIButton *button = [UIButton buttonWithNormalImageName:normal highlightImageName:highlight];
    
    if ( textColor )
    {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    if ( font )
    {
        button.titleLabel.font = font;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
           LocalizedImageName:(NSString *)normal highlightImageName:(NSString *)highlight
{
    UIButton *button = [UIButton buttonWithLocalizedNormalImageName:normal highlightImageName:highlight];
    
    if ( textColor )
    {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    if ( font )
    {
        button.titleLabel.font = font;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                 shawdowColor:(UIColor *)shadowColor  shawdowOffset:(CGSize)offset
                        image:(UIImage *)normal highlightImage:(UIImage *)highlight
{
    UIButton *button = [UIButton buttonWithTitle:title font:font
                                       textColor:textColor image:normal highlightImage:highlight];
    if ( shadowColor )
    {
        [button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    }
    button.titleLabel.shadowOffset = offset;
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                 shawdowColor:(UIColor *)shadowColor shawdowOffset:(CGSize)offset
                    imageName:(NSString *)normal highlightImageName:(NSString *)highlight
{
    UIButton *button = [UIButton buttonWithTitle:title font:font textColor:textColor
                                        imageName:normal highlightImageName:highlight];
    if ( shadowColor )
    {
        [button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    }
    button.titleLabel.shadowOffset = offset;
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor
                 shawdowColor:(UIColor *)shadowColor shawdowOffset:(CGSize)offset
           LocalizedImageName:(NSString *)normal highlightImageName:(NSString *)highlight
{
    UIButton *button = [UIButton buttonWithTitle:title font:font textColor:textColor
                                       LocalizedImageName:normal highlightImageName:highlight];
    if ( shadowColor )
    {
        [button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    }
    button.titleLabel.shadowOffset = offset;
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor
{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button sizeToFit];
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor highlightColor:(UIColor *)hightlight backgroundColor:(UIColor *)backgroundColor
{
    UIButton *button = [UIButton buttonWithTitle:title font:font textColor:textColor backgroundColor:backgroundColor];
    [button setTitleColor:hightlight forState:UIControlStateHighlighted];
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)background
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = background;
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)background
                        title:(NSString *)title font:(UIFont *)font textColor:(UIColor *) textColor
{
    UIButton *button = [UIButton buttonWithFrame:frame backgroundColor:background];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor resizableImage:(UIImage *)normal
      resizableHighlightImage:(UIImage *)highlight titleEdgeInsets:(UIEdgeInsets)insets
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
    
    CGRect frame = button.frame;
    CGSize size = [title sizeWithFont:font];
    frame.size.width = insets.left + size.width + insets.right;
    frame.size.height = insets.top + size.height + insets.bottom;
    button.frame = frame;
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor resizableImage:(UIImage *)normal
      resizableHighlightImage:(UIImage *)highlight leftInset:(CGFloat)leftInset rightInset:(CGFloat)rightInset
{
    return [self buttonWithTitle:title font:font
                       textColor:textColor resizableImage:normal
         resizableHighlightImage:highlight leftInset:leftInset rightInset:rightInset
            minWidthEqualToImage:NO];
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font
                    textColor:(UIColor *)textColor resizableImage:(UIImage *)normal
      resizableHighlightImage:(UIImage *)highlight leftInset:(CGFloat)leftInset rightInset:(CGFloat)rightInset
         minWidthEqualToImage:(BOOL)hasMinWidth
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
    
    CGRect frame = button.frame;
    CGSize size = [title sizeWithFont:font];
    frame.size.width = leftInset + size.width + rightInset;
    if ( hasMinWidth && frame.size.width < normal.size.width ) {
        frame.size.width = normal.size.width;
    }
    frame.size.height = normal.size.height;
    button.frame = frame;
    
    return button;
}

+ (UIButton *)buttonWithNormalImageName: (NSString *) normalName
                     highlightImageName: (NSString *) highlightName
                                  title: (NSString *) titleText
{
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    if ( normalName )
    {
        [button setBackgroundImage: [UIImage imageNamed: normalName]
                          forState: UIControlStateNormal];
    }
    
    if ( highlightName )
    {
        [button setBackgroundImage: [UIImage imageNamed: highlightName]
                          forState: UIControlStateHighlighted];
    }
    [button sizeToFit];
    
    if (titleText)
    {
        [button setTitle: titleText forState: UIControlStateNormal];
    }
    
    return button;
}

+ (UIButton *)buttonWithCustomView:(UIView *)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = view.bounds;
    [button addSubview:view];

    return button;
}

@end
