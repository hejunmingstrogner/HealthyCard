//
//  ProxyPDAVertificationPacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ProxyPDAVertificationPacket.h"
#import "Constants.h"
#import "HMDataOperate.h"

@implementation ProxyPDAVertificationPacket

-(instancetype)init{
    if (self = [super init]){
        self.protocalNum = PROXY_PDA_VERIFICATION;
    }
    return self;
}

#pragma mark - Override Methods
-(NSMutableData*)readData{
    NSMutableData* resultData = [[NSMutableData alloc] init];
    [[HMDataOperate getInstance] writeShort:self.protocalNum To:resultData];
    [[HMDataOperate getInstance] write256String:self.phoneNum To:resultData];
    return resultData;
}


@end
