//
//  ProxyHeartBeatPacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ProxyHeartBeatPacket.h"
#import "Constants.h"
#import "HMDataOperate.h"

@implementation ProxyHeartBeatPacket

-(instancetype)init{
    if (self = [super init]){
        self.protocalNum = SERVER_STATUS_ECHO;
    }
    return self;
}

#pragma mark - Override Methods
-(NSMutableData*)readData{
    NSMutableData* resultData = [[NSMutableData alloc] init];
    [[HMDataOperate getInstance] writeShort:self.protocalNum To:resultData];
    return resultData;
}

@end
