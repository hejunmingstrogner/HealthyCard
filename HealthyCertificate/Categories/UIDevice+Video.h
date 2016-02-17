//
//  UIDevice+Video.h
//  SioEyeAPP
//
//  Created by Hu Yi on 15/7/4.
//  Copyright (c) 2015年 CDCKT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    UIDeviceUnkown,
    UIDeviceSimulator,

    UIDeviceIPhone1G = 0x1000,
    UIDeviceIPhone3G,
    UIDeviceIPhone3GS,
    UIDeviceIPhone4,
    UIDeviceIPhone4S,
    UIDeviceIPhone5,
    UIDeviceIPhone5C,
    UIDeviceIPhone5S,
    UIDeviceIPhone6,
    UIDeviceIPhone6P,
    UIDeviceIPhone6S,
    UIDeviceIPhone6SP,

    UIDeviceIPodTouch1G = 0x2000,
    UIDeviceIPodTouch2G,
    UIDeviceIPodTouch3G,
    UIDeviceIPodTouch4G,
    UIDeviceIPodTouch5G,
    UIDeviceIPodTouch6G,

    UIDeviceIPad = 0x3000,
    UIDeviceIPad2,
    UIDeviceIPadMini,
    UIDeviceIPad3,
    UIDeviceIPad4,
    UIDeviceIPadAir,
    UIDeviceIPadMinRetina
}UIDeviceType;

struct UIVideoFormat{
    CGSize size; //Video size
    CGFloat fps; // Video fps
};
typedef struct UIVideoFormat UIVideoFormat;

CG_INLINE UIVideoFormat UIVideoFormatMake(CGSize size, CGFloat fps){
    UIVideoFormat format;
    format.size.height = size.height;
    format.size.width = size.width;
    format.fps = fps;

    return format;
}

@interface UIDevice (Video)

- (NSString *)deviceString;
- (UIDeviceType)deviceType;
- (BOOL)isVideoSupported:(UIVideoFormat)video;

@end
