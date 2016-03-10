//
//  HMNetworkEngine.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HMNetworkEngineDelegate <NSObject>

@optional
-(void)setUpControlSucceed;
-(void)setUpControlFailed;

-(void)reportResultReturnUrlPacketSucceed:(NSString*)urlStr;


//这里解析服务端返回数据以后可以优化一下，现在是分别针对不同的操作有不同的函数来处理
/**
 *  get the server list from data stream
 *
 *  @param data data stream
 */
-(void)queueServerListResult:(NSData*)data Index:(NSInteger*)index;

-(void)getLoginInfoSucceed;

@end

@interface HMNetworkEngine : NSObject

+(instancetype)getInstance;


/**
 *  setup the socket, connect to server
 */
-(void)startControl;

/**
 *  查询得到服务机构列表（只有一个）
 */
-(void)queryServerList;

/**
 *  登录信息请求协议
 *
 *  @param phoneNum 登录验证过的手机号
 */
-(void)askLoginInfo:(NSString*)phoneNum;

/**
 *  得到体检报告的url
 *
 *  @param examinationCode 体检编号
 */
-(void)getReportQueryUrl:(NSString*)examinationCode;


/**
 *  定位成功后，向服务端发送定位信息包
 *
 *  @param custCode          客户编号
 *  @param linkPhone         电话号码
 *  @param lo                定位经度
 *  @param la                定位纬度
 *  @param positionDirection 定位方向
 *  @param positionAddr      定位地址
 *  @param locTime           定位时间
 *  @param cityName          定位城市
 */
-(void)sendCustomerCode:(NSString*)custCode
              LinkPhone:(NSString*)linkPhone
                     LO:(NSString*)lo
                     LA:(NSString*)la
      PositionDirection:(NSString*)positionDirection
           PositionAddr:(NSString*)positionAddr
                LocTime:(NSDate*)locTime
               CityName:(NSString*)cityName;




@property (nonatomic, weak) id<HMNetworkEngineDelegate> delegate;

@property (nonatomic, copy) NSString* serverID;

@end
