//
//  PackageOperation.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePacket.h"

#import "PersonInfoOfPhonePacket.h"
#import "CompanyInfoOfPhonePacket.h"

@interface PackageOperation : NSObject

+(instancetype)getInstance;


/**
 *  get the outer layer protocol
 *
 *  @param data receive data
 *
 *  @return the outer layer protocol
 */
-(short)outerLayerProtocol:(NSData*)data Index:(NSInteger*)index;

/**
 *  get the inner layer protocol
 *
 *  @param data  receive data
 *  @param index innner layer protocol
 *
 *  @return the inner layer protocol
 */
-(short)innerLayerProtocol:(NSData*)data Index:(NSInteger*)index;


#pragma mark - 为发送到代理服务器的包添加包头信息
/**
 *  add proxy layer to packet and convert it to NSData
 *
 *  @param packet the source packet
 *  @param data   the result NSData
 */
-(void)addProxyLayerWith:(BasePacket*) packet To:(NSMutableData*)data;


#pragma mark - 为发送到排队服务器的包添加包头信息
/**
 *  add queue layer to packet and convert it to NSData
 *
 *  @param packet the source packet
 *  @param data   the result NSData
 */
-(void)addQueueLayerWith:(BasePacket*) packet To:(NSMutableData*)data;

/**
 *  得到个人信息和单位信息
 *
 *  @param personInfo  个人信息
 *  @param companyInfo 单位信息
 *  @param index       data的index
 *  @param data        数据流
 */
-(void)getPersonInfo:(PersonInfoOfPhonePacket*)personInfo CompanyInfo:(CompanyInfoOfPhonePacket*)companyInfo Index:(NSInteger*)index From:(NSData*)data;

@end
