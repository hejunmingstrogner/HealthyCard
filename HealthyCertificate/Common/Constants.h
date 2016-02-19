//
//  Constants.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import "PersonInfoOfPhonePacket.h"
#import "CompanyInfoOfPhonePacket.h"

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

#define SERVER_PROXY_LIST_QUERY 27//从主服务器查询被代理的服务器列表(StringPacket)

#define PROXY_PDA_VERIFICATION 1605 //app向智能导引服务器发送电话号码 登录信息请求
#define PROXY_PDA_CUSTOMER_INFO 1609 // 智能导引服务器向app发送电话号码相关的客户信息

#define SERVER_PROXY_CLIENT_DATA 25	//统一认证服务器发给app的数据
#define SERVER_PROXY_SERVER_DATA 26	//app发给统一认证服务器的数据

//#define SERVER_EXTERNAL_SERVER_DATA 21 //app发给排队服务器的数据
//#define SERVER_EXTERNAL_CLIENT_DATA 22 //排队服务器发送给app的数据

//心跳包
//pda与排队服务器的
#define APP_SERVER_PDA_HEARTBEAT 1608

typedef NS_ENUM(NSInteger, PACKAGEPART)
{
    PACKAGE_HEADER,
    PACKAGE_BODY
};

extern PersonInfoOfPhonePacket* gPersonInfo;
extern CompanyInfoOfPhonePacket* gCompanyInfo;

#define kiOS6NavigationBarHeight 44
#define kiOS7NavigationBarHeight 64

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight (IsIOS7() ? kiOS7NavigationBarHeight : kiOS6NavigationBarHeight)
#define IsIOS7() ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0)


#define MO_RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define MO_RGBCOLOR1(c) [UIColor colorWithRed:c/255.0 green:c/255.0 blue:c/255.0 alpha:1]
#define MO_RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define FIT_WIDTH(width)    SCREEN_WIDTH/414*width         // 1080 dp
#define FIT_HEIGHT(height)  SCREEN_HEIGHT/736*height

#define FIT_FONTSIZE(size)  SCREEN_WIDTH / 414 * 72 / 96 * size

#define PXFIT_WIDTH(width)  SCREEN_WIDTH/414*width*3/5.2   // 1080px
#define PXFIT_HEIGHT(height)  SCREEN_HEIGHT/736*height*3/5.2

#define DataOperate [HMDataOperate getInstance]

#endif /* Constants_h */
