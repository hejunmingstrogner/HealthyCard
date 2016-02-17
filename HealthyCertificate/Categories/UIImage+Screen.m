//
//  UIImage+Screen.m
//  SioEyeAPP
//
//  Created by Hu Yi on 15/6/19.
//  Copyright (c) 2015年 CDCKT. All rights reserved.
//

#import "UIImage+Screen.h"

@implementation UIImage (Screen)

+ (NSString *)screenWidthImageName:(NSString *)name
{
    return [NSString stringWithFormat:@"%@-%dw", name,
            (int)[UIScreen mainScreen].bounds.size.width];
}

+ (UIImage *)screenWidthImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:[UIImage screenWidthImageName:name]];
    return image;
}

+ (NSString *)screenHeightImageName:(NSString *)name
{
    return [NSString stringWithFormat:@"%@-%dh", name,
            (int)[UIScreen mainScreen].bounds.size.height];
}

+ (UIImage *)screenHeigthImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:[UIImage screenHeightImageName:name]];
    return image;
}

@end
