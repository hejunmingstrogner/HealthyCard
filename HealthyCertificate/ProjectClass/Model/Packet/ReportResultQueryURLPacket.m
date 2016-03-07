//
//  ReportResultQueryURLPacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ReportResultQueryURLPacket.h"
#import "HMDataOperate.h"

#import "Constants.h"

@implementation ReportResultQueryURLPacket

#pragma


#pragma mark - Override Methods
-(NSMutableData*)readData{
    NSMutableData* resultData = [[NSMutableData alloc] init];
    [[HMDataOperate getInstance] writeShort:self.protocalNum To:resultData];
    [[HMDataOperate getInstance] writeByte:self.bType To:resultData];
    return resultData;
}


@end
