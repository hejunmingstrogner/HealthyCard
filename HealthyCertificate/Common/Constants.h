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
#import <RealReachability.h>

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
//#define SERVER_EXTERNAL_CLIENT_DATA 22 //排队服务器发送给app的数据 REPORT_RESULT_QUERY_URL

#define REPORT_RESULT_QUERY_URL 1603 //移动平台体检报告URL查询协议
#define REPORT_RESULT_RETURN_URL 1604 //移动平台体检报告URL返回协议

#define CUSTOMER_POSITION_LOG   1617 //定位信息

//心跳包
//pda与排队服务器的
#define APP_SERVER_PDA_HEARTBEAT 1608

typedef NS_ENUM(NSInteger, PACKAGEPART)
{
    PACKAGE_HEADER,
    PACKAGE_BODY
};

typedef NS_ENUM(NSInteger, SWITCH_STYLE)
{
    SWITCH_POP,
    SWITCH_MISS
};

extern PersonInfoOfPhonePacket* gPersonInfo;
extern CompanyInfoOfPhonePacket* gCompanyInfo;
extern RealReachability* reachAbility;

extern NSString *gCurrentCityName;  // 当前城市名字

extern BOOL   _isLocationInfoHasBeenSent; //判断是否已经向服务端发送过定位信息

// 设置各种长度最大的限制
#define NAME_LENGTH 20 // 名字长度
#define IDCARD_LENGTH 18 // 身份证长度
#define TELPHONENO_LENGTH 11 // 电话号码长度
#define DEFAULT_LENGTH  100  // 默认长度


#define kiOS6NavigationBarHeight 44
#define kiOS7NavigationBarHeight 44


#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight (IsIOS7() ? kiOS7NavigationBarHeight : kiOS6NavigationBarHeight)
#define kStatusBarHeight 20
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

#define GetUserType [[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] integerValue]
#define SetUserType(type) [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", type] forKey:@"userType"]          // 设置用户类型，1:个人  2:单位

#define SetUuidTimeOut(timeout) [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", timeout] forKey:@"hc_uuid_timeout"]
#define GetUuidTimeOut [[NSUserDefaults standardUserDefaults] objectForKey:@"hc_uuid_timeout"]

#define SetUuid(uuid) [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", uuid] forKey:@"hc_uuid"]
#define GetUuid [[NSUserDefaults standardUserDefaults] objectForKey:@"hc_uuid"]

#define SetLastLoginTime(lastLoginTime) [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lld", lastLoginTime] forKey:@"hc_lastloign_time"]
#define GetLastLoginTime [[NSUserDefaults standardUserDefaults] objectForKey:@"hc_lastloign_time"]

#define SetPhoneNumber(phoneNumber) [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", phoneNumber] forKey:@"hc_phoneNumber"]
#define GetPhoneNumber [[NSUserDefaults standardUserDefaults] objectForKey:@"hc_phoneNumber"]

//灰色不可用
#define HC_Gray_unable 0xcacaca
//灰色字体
#define HC_Gray_Text 0x888888
//灰色描边
#define HC_Gray_Egdes 0xe6e6e6
//灰色横线
#define HC_Gray_Line 0xcccccc
//容器背景
#define HC_Base_BackGround 0xf5f5f5
//绿色正常/按下
#define HC_Base_Green 0x5FB22C
#define HC_BASE_Green_Pressed 0x529d23
//蓝色 字
#define HC_Blue_Text 0x2080be
//蓝色 正常/按下
#define HC_Base_Blue 0x06b6f0
#define HC_Base_Blue_Pressed 0x0f9fce


//一些提示语
#define InputLocationInfo @"请填写预约地址"
#define InputDateInfo     @"请填写预约时间"
#define InputTelephone    @"请填写联系电话"

#define InputName         @"请填写姓名"
#define InputGender       @"请填写性别"
#define InputIndustry     @"请填写行业"
#define InputIdCard       @"请填写身份证号"

#define MakeAppointmentFailed @"预约失败，请重试"
#define UploadHealthyPicFailed @"上传健康证图片失败,请重试"

#endif /* Constants_h */
