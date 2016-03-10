//
//  CustomerPositionLogPacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerPositionLogPacket.h"

#import "Constants.h"
#import "HMDataOperate.h"

@implementation CustomerPositionLogPacket

-(instancetype)init{
    if (self = [super init])
    {
        self.protocalNum = CUSTOMER_POSITION_LOG;
    }
    
    return self;
}

#pragma mark - Override Methods
-(NSMutableData*)readData
{
    NSMutableData* resultData = [[NSMutableData alloc] init];
    
    [[HMDataOperate getInstance] writeShort:self.protocalNum To:resultData];
    [[HMDataOperate getInstance] writeInt:self.m_nUID To:resultData];
    [[HMDataOperate getInstance] write256String:self.m_strCustCode To:resultData];
    [[HMDataOperate getInstance] write256String:self.m_strLinkPhone To:resultData];
    [[HMDataOperate getInstance] writeFloat:self.m_fPositionLO To:resultData];
    [[HMDataOperate getInstance] writeFloat:self.m_fPositionLA To:resultData];
    [[HMDataOperate getInstance] writeFloat:self.m_fPositionDirection To:resultData];
    [[HMDataOperate getInstance] write256String:self.m_strPositionAddr To:resultData];
    [[HMDataOperate getInstance] writeDate:self.m_tAtTheTime To:resultData];
    [[HMDataOperate getInstance] write256String:self.m_strCityName To:resultData];
    return resultData;
}


@end
