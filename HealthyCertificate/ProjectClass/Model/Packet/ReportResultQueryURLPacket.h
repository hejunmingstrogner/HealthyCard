//
//  ReportResultQueryURLPacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BasePacket.h"

@interface ReportResultQueryURLPacket : BasePacket

//客户体检编号
@property (nonatomic, copy) NSString* strCheckCode;

//1：科室结果 2：体检报告
@property (nonatomic, assign) Byte bType;


@end
