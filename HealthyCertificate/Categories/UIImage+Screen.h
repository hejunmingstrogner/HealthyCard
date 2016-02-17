//
//  UIImage+Screen.h
//  SioEyeAPP
//
//  Created by Hu Yi on 15/6/19.
//  Copyright (c) 2015年 CDCKT. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Get image or name for current screen width or height. It follow the rule below
 * 1. Image for width: image -> image-320w or image-375w or image-414w
 * 2. Image for height image -> image-480h or image-568h or image-667h or image-736h
 */
@interface UIImage (Screen)

+ (NSString *)screenWidthImageName:(NSString *)name;
+ (UIImage *)screenWidthImage:(NSString *)name;


+ (NSString *)screenHeightImageName:(NSString *)name;
+ (UIImage *)screenHeigthImage:(NSString *)name;

@end
