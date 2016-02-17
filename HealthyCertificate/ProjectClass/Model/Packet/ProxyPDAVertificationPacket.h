//
//  ProxyPDAVertificationPacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BasePacket.h"

/**
 *  app向智能引导服务器发送电话号码相关的客户信息
 */
@interface ProxyPDAVertificationPacket : BasePacket

@property (nonatomic, copy) NSString* phoneNum;

@end
