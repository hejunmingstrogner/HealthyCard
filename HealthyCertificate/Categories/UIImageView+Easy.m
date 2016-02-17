//
//  UIImageView+Easy.m
//  ByIM
//
//  Created by whrttv.com on 13-6-22.
//  Copyright (c) 2013年 whrttv.com. All rights reserved.
//

#import "UIImageView+Easy.h"

@implementation UIImageView (Easy)

+ (UIImageView *)imageViewWithImage:(UIImage *)image
{
    return [[UIImageView alloc] initWithImage:image];
}

+ (UIImageView *)imageViewWithImageName:(NSString *)image
{
    UIImage *img = [UIImage imageNamed:image];
    
    return [UIImageView imageViewWithImage:img];
}

+ (UIImageView *)imageViewWithLocalizedImageName:(NSString *)image
{
    UIImage *img = [UIImage imageNamed:NSLocalizedString(image, nil)];
    
    return [UIImageView imageViewWithImage:img];
}

+ (UIImageView *)imageViewWithImage:(UIImage *)image highlightedImage:(UIImage *)highlight
{
    return [[UIImageView alloc] initWithImage:image highlightedImage:highlight];
}

+ (UIImageView *)imageViewWithImageName:(NSString *)image highlightedImage:(NSString *)highlight
{
    UIImage *normal = [UIImage imageNamed:image];
    UIImage *highlightedImage = [UIImage imageNamed:highlight];
    
    return [UIImageView imageViewWithImage:normal highlightedImage:highlightedImage];
}

+ (UIImageView *)imageViewWithLocalizedImageName:(NSString *)image highlightedImage:(NSString *)highlight
{
    UIImage *normal = [UIImage imageNamed:NSLocalizedString(image, nil)];
    UIImage *highlightedImage = [UIImage imageNamed:NSLocalizedString(highlight, nil)];
    
    return [UIImageView imageViewWithImage:normal highlightedImage:highlightedImage];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    return imageView;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [UIImageView imageViewWithFrame:frame];
    imageView.image = image;
    
    return imageView;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)image
{
    UIImage *img = [UIImage imageNamed:image];
    
    return [UIImageView imageViewWithFrame:frame image:img];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame LocalizedImageName:(NSString *)image
{
    UIImage *img = [UIImage imageNamed:NSLocalizedString(image, nil)];
    
    return [UIImageView imageViewWithFrame:frame image:img];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                image:(UIImage *)image higlightedImage:(UIImage *)highlight
{
    UIImageView *imageView = [UIImageView imageViewWithFrame:frame image:image];
    imageView.highlightedImage = highlight;
    
    return imageView;
}
+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)image higlightedImage:(NSString *)highlight
{
    UIImageView *imageView = [UIImageView imageViewWithFrame:frame imageName:image];
    imageView.highlightedImage = [UIImage imageNamed:highlight];
    
    return imageView;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                 localizedImageName:(NSString *)image higlightedImage:(NSString *)highlight
{
    UIImageView *imageView = [UIImageView imageViewWithFrame:frame LocalizedImageName:image];
    imageView.highlightedImage = [UIImage imageNamed:NSLocalizedString(highlight, nil)];
    
    return imageView;
}

@end
