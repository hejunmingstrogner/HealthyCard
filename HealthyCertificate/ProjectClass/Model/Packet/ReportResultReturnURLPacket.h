//
//  ReportResultReturnURLPacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BasePacket.h"

@interface ReportResultReturnURLPacket : BasePacket

@property (nonatomic, copy) NSString* strReportURL;

@end
