//
//  QueueServerHeartBeatPacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BasePacket.h"

@interface QueueServerHeartBeatPacket : BasePacket
/**
 *  0 代表心跳机制 1 代表下线消息
 */
@property (nonatomic, assign) Byte bType;

-(instancetype)initWithType:(Byte)type;

@end
