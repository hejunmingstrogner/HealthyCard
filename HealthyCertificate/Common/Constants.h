//
//  Constants.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define PACKAGE_LENGTH 4

#define SHORT_TYPE_BYTE 2
#define BYTE_TYPE_BYTE 1
#define INT_TYPE_BYTE 4
#define LONG_TYPE_BYTE 8

//http://lt.witaction.com:8080
//#define SOCKET_HOST @"cert.witaction.com"
#define SOCKET_HOST @"yiscert.witaction.com"
//#define SOCKET_HOST @"121.199.30.91"
//#define SOCKET_HOST @"10.254.244.59"
#define SOCKET_PORT 6413 //服务器端口号

#define SERVER_STATUS_ECHO 19

//心跳包
//pda与排队服务器的
#define APP_SERVER_PDA_HEARTBEAT 1608

typedef NS_ENUM(NSInteger, PACKAGEPART)
{
    PACKAGE_HEADER,
    PACKAGE_BODY
};


#define kiOS6NavigationBarHeight 44
#define kiOS7NavigationBarHeight 64

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight (IsIOS7() ? kiOS7NavigationBarHeight : kiOS6NavigationBarHeight)
#define IsIOS7() ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0)


#define MO_RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define MO_RGBCOLOR1(c) [UIColor colorWithRed:c/255.0 green:c/255.0 blue:c/255.0 alpha:1]
#define MO_RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define FIT_WIDTH(width)    SCREEN_WIDTH/414*width
#define FIT_HEIGHT(height)  SCREEN_HEIGHT/736*height

#define FIT_FONTSIZE(size)  SCREEN_WIDTH / 414 * 72 / 96 * size


#endif /* Constants_h */
