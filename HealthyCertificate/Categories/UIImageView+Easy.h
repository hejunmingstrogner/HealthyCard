//
//  UIImageView+Easy.h
//  ByIM
//
//  Created by whrttv.com on 13-6-22.
//  Copyright (c) 2013年 whrttv.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Easy)

+ (UIImageView *)imageViewWithImage:(UIImage *)image;
+ (UIImageView *)imageViewWithImageName:(NSString *)image;
+ (UIImageView *)imageViewWithLocalizedImageName:(NSString *)image;

+ (UIImageView *)imageViewWithImage:(UIImage *)image highlightedImage:(UIImage *)highlight;
+ (UIImageView *)imageViewWithImageName:(NSString *)image highlightedImage:(NSString *)highlight;
+ (UIImageView *)imageViewWithLocalizedImageName:(NSString *)image highlightedImage:(NSString *)highlight;

+ (UIImageView *)imageViewWithFrame:(CGRect)frame;
+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image;
+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)image;
+ (UIImageView *)imageViewWithFrame:(CGRect)frame LocalizedImageName:(NSString *)image;

+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image higlightedImage:(UIImage *)highlight;
+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)image higlightedImage:(NSString *)highlight;
+ (UIImageView *)imageViewWithFrame:(CGRect)frame localizedImageName:(NSString *)image higlightedImage:(NSString *)highlight;


@end
