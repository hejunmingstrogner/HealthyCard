//
//  QueueServerHeartBeatPacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "QueueServerHeartBeatPacket.h"

#import "Constants.h"

@implementation QueueServerHeartBeatPacket

-(instancetype)initWithType:(Byte)type{
    if (self = [super init]) {
        self.protocalNum = APP_SERVER_PDA_HEARTBEAT;
        self.bType = type;
    }
    return self;
}


@end
