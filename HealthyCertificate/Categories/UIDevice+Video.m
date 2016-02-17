//
//  UIDevice+Video.m
//  SioEyeAPP
//
//  Created by Hu Yi on 15/7/4.
//  Copyright (c) 2015年 CDCKT. All rights reserved.
//

#import "UIDevice+Video.h"

#include <sys/sysctl.h>

@implementation UIDevice (Video)

// iPhone
#define kDeviceModelIPhone1G @"iPhone1,1"
#define kDeviceModelIPhone3G @"iPhone1,2"
#define kDeviceModelIPhone3GS @"iPhone2,1"
#define kDeviceModelIPhone4 @"iPhone3,1"
#define kDeviceModelIPhone4_1 @"iPhone3,3"
#define kDeviceModelIPhone4S @"iPhone4,1"
#define kDeviceModelIPhone5 @"iPhone5,1"
#define kDeviceModelIPhone5_1 @"iPhone5,2"
#define kDeviceModelIPhone5C @"iPhone5,3"
#define kDeviceModelIPhone5C_1 @"iPhone5,4"
#define kDeviceModelIPhone5S @"iPhone6,1"
#define kDeviceModelIPhone5S_1 @"iPhone6,2"
#define kDeviceModelIPhone6 @"iPhone7,2"
#define kDeviceModelIPhone6P @"iPhone7,1"
#define kDeviceModelIPhone6S @"iPhone8,2"
#define kDeviceModelIPhone6SP @"iPhone8,1"

// iPod Touch
#define kDeviceModelIPodTouch1G @"iPod1,1"
#define kDeviceModelIPodTouch2G @"iPod2,1"
#define kDeviceModelIPodTouch3G @"iPod3,1"
#define kDeviceModelIPodTouch4G @"iPod4,1"
#define kDeviceModelIPodTouch5G @"iPod5,1"
#define kDeviceModelIPodTouch6G @"iPod7,1"

// iPad
#define kDeviceModelIPad @"iPad1,1"
#define kDeviceModelIPad2 @"iPad2,1"
#define kDeviceModelIPad2_1 @"iPad2,2"
#define kDeviceModelIPad2_2 @"iPad2,3"
#define kDeviceModelIPad2_3 @"iPad2,4"
#define kDeviceModelIPadMini @"iPad2,5"
#define kDeviceModelIPadMini_1 @"iPad2,6"
#define kDeviceModelIPadMini_2 @"iPad2,7"
#define kDeviceModelIPad3 @"iPad3,1"
#define kDeviceModelIPad3_1 @"iPad3,2"
#define kDeviceModelIPad3_2 @"iPad3,3"
#define kDeviceModelIPad4 @"iPad3,4"
#define kDeviceModelIPad4_1 @"iPad3,5"
#define kDeviceModelIPad4_2 @"iPad3,6"
#define kDeviceModelIPadAir @"iPad4,1"
#define kDeviceModelIPadAir_1 @"iPad4,2"
#define kDeviceModelIPadMiniRetina @"iPad4,4"
#define kDeviceModelIPadMiniRetina_1 @"iPad4,5"

// Simulatoe
#define kDeviceModelSimulator @"i386"
#define kDeviceModelSimulator_1 @"x86_64"

// Video Format
#define UIVideoFormat480P30FPS UIVideoFormatMake(CGSizeMake(640, 480), 30)
#define UIVideoFormat720P30FPS UIVideoFormatMake(CGSizeMake(1280, 720), 30)
#define UIVideoFormat1080P30FPS UIVideoFormatMake(CGSizeMake(1920, 1080), 30)
#define UIVideoFormat1080P60FPS UIVideoFormatMake(CGSizeMake(1920, 1080), 60)
#define UIVideoFormat4K30FPS UIVideoFormatMake(CGSizeMake(4096, 2160), 30)

- (NSString *)deviceString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);

    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);

    NSString *device = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    return device;
}


- (UIVideoFormat)supportedVideoFormat:(UIDeviceType)type
{
    UIVideoFormat format;
    switch (type) {
        case UIDeviceIPhone1G:
        case UIDeviceIPhone3G:
        case UIDeviceIPhone3GS:
        case UIDeviceIPodTouch1G:
        case UIDeviceIPodTouch2G:
        case UIDeviceIPodTouch3G:
        {
            format = UIVideoFormat480P30FPS;
            break;
        }
        case UIDeviceIPhone4:
        case UIDeviceIPodTouch4G:
        {
            format = UIVideoFormat720P30FPS;
            break;
        }
        case UIDeviceIPhone4S:
        case UIDeviceIPhone5:
        case UIDeviceIPhone5C:
        case UIDeviceIPodTouch5G:
        case UIDeviceIPodTouch6G:
        case UIDeviceIPad:
        case UIDeviceIPad2:
        case UIDeviceIPadMini:
        case UIDeviceIPad3:
        case UIDeviceIPad4:
        {
            format = UIVideoFormat1080P30FPS;
            break;
        }
        case UIDeviceIPhone5S:
        case UIDeviceIPhone6:
        case UIDeviceIPhone6P:
        case UIDeviceIPadAir:
        case UIDeviceIPadMinRetina:
        case UIDeviceSimulator:
        {
            format = UIVideoFormat1080P60FPS;
            break;
        }
        case UIDeviceIPhone6S:
        case UIDeviceIPhone6SP:
        {
            format = UIVideoFormat4K30FPS;
            break;
        }
        default:
            format.size = CGSizeZero;
            format.fps = 0;
            break;
    }

    return format;
}

- (UIDeviceType)deviceType
{
    UIDeviceType type = UIDeviceUnkown;
    NSString *device = [self deviceString];
    if ( [device isEqualToString:kDeviceModelIPhone1G] )
    {
        type = UIDeviceIPhone1G;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone3G] )
    {
        type = UIDeviceIPhone3G;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone3GS] )
    {
        type = UIDeviceIPhone3GS;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone4]
             || [device isEqualToString:kDeviceModelIPhone4_1] )
    {
        type = UIDeviceIPhone4;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone4S] )
    {
        type = UIDeviceIPhone4S;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone5]
             || [device isEqualToString:kDeviceModelIPhone5_1] )
    {
        type = UIDeviceIPhone5;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone5C]
             || [device isEqualToString:kDeviceModelIPhone5C_1] )
    {
        type = UIDeviceIPhone5C;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone5S]
             || [device isEqualToString:kDeviceModelIPhone5S_1] )
    {
        type = UIDeviceIPhone5S;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone6] )
    {
        type = UIDeviceIPhone6;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone6P] )
    {
        type = UIDeviceIPhone6P;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone6S] )
    {
        type = UIDeviceIPhone6S;
    }
    else if ( [device isEqualToString:kDeviceModelIPhone6SP] )
    {
        type = UIDeviceIPhone6SP;
    }
    else if ( [device isEqualToString:kDeviceModelIPodTouch1G] )
    {
        type = UIDeviceIPodTouch1G;
    }
    else if ( [device isEqualToString:kDeviceModelIPodTouch2G] )
    {
        type = UIDeviceIPodTouch2G;
    }
    else if ( [device isEqualToString:kDeviceModelIPodTouch3G] )
    {
        type = UIDeviceIPodTouch3G;
    }
    else if ( [device isEqualToString:kDeviceModelIPodTouch4G] )
    {
        type = UIDeviceIPodTouch4G;
    }
    else if ( [device isEqualToString:kDeviceModelIPodTouch5G] )
    {
        type = UIDeviceIPodTouch5G;
    }
    else if ( [device isEqualToString:kDeviceModelIPodTouch6G] )
    {
        type = UIDeviceIPodTouch6G;
    }
    else if ( [device isEqualToString:kDeviceModelIPad] )
    {
        type = UIDeviceIPad;
    }
    else if ( [device isEqualToString:kDeviceModelIPad2]
             || [device isEqualToString:kDeviceModelIPad2_1]
             || [device isEqualToString:kDeviceModelIPad2_2]
             || [device isEqualToString:kDeviceModelIPad2_3] )
    {
        type = UIDeviceIPad2;
    }
    else if ( [device isEqualToString:kDeviceModelIPadMini]
             || [device isEqualToString:kDeviceModelIPadMini_1]
             || [device isEqualToString:kDeviceModelIPadMini_2] )
    {
        type = UIDeviceIPadMini;
    }
    else if ( [device isEqualToString:kDeviceModelIPad3]
             || [device isEqualToString:kDeviceModelIPad3_1]
             || [device isEqualToString:kDeviceModelIPad3_2] )
    {
        type = UIDeviceIPad3;
    }
    else if ( [device isEqualToString:kDeviceModelIPad4]
             || [device isEqualToString:kDeviceModelIPad4_1]
             || [device isEqualToString:kDeviceModelIPad4_2] )
    {
        type = UIDeviceIPad4;
    }
    else if ( [device isEqualToString:kDeviceModelIPadAir]
             || [device isEqualToString:kDeviceModelIPadAir_1] )
    {
        type = UIDeviceIPadAir;
    }
    else if ( [device isEqualToString:kDeviceModelIPadMiniRetina]
             || [device isEqualToString:kDeviceModelIPadMiniRetina_1] )
    {
        type = UIDeviceIPadMinRetina;
    }
    else if ( [device isEqualToString:kDeviceModelSimulator]
             || [device isEqualToString:kDeviceModelSimulator_1] )
    {
        type = UIDeviceSimulator;
    }

    return type;
}

- (BOOL)isVideoSupported:(UIVideoFormat)video
{
    BOOL supported = NO;
    UIVideoFormat format = [self supportedVideoFormat:[self deviceType]];
    if ( (video.size.height == format.size.height && video.size.width == format.size.width && video.fps <= format.fps)
        || (video.size.height < format.size.height && video.size.width < format.size.width && video.fps <= 60) )
    {
        supported = YES;
    }

    return supported;
}

@end
