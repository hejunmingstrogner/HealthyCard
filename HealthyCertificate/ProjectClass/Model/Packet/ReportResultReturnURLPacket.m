//
//  ReportResultReturnURLPacket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ReportResultReturnURLPacket.h"

#import "Constants.h"
#import "HMDataOperate.h"
#import "HttpNetworkManager.h"


@implementation ReportResultReturnURLPacket

#pragma mark - init
-(id)init{
    if (self = [super init]){
        self.protocalNum = REPORT_RESULT_RETURN_URL;
    }
    return self;
}


#pragma mark - Override Methods
-(void)writeData:(NSData *)data Index:(NSInteger *)index{
    self.strReportURL = [DataOperate readShortString:data Index:index];
}

@end
