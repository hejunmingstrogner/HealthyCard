//
//  UIScreen+Type.m
//  SioEyeAPP
//
//  Created by Hu Yi on 15/5/13.
//  Copyright (c) 2015年 CDCKT. All rights reserved.
//

#import "UIScreen+Type.h"

@implementation UIScreen (Type)

+ (BOOL)is320WidthScreen
{
    return [UIScreen mainScreen].bounds.size.width == 320;
}

+ (BOOL)is375WidthScreen
{
    return [UIScreen mainScreen].bounds.size.width == 375;
}

+ (BOOL)is414WidthScreen
{
    return [UIScreen mainScreen].bounds.size.width == 414;
}

+ (BOOL)is480HeightScreen
{
    return [UIScreen mainScreen].bounds.size.height == 480;
}

+ (BOOL)is568HeightScreen
{
    return [UIScreen mainScreen].bounds.size.height == 568;
}

+ (BOOL)is667HeightScreen
{
    return [UIScreen mainScreen].bounds.size.height == 667;
}

+ (BOOL)is736HeightScreen
{
    return [UIScreen mainScreen].bounds.size.height == 736;
}

@end
