//
//  BRContract.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BRContract.h"

@implementation BRContract

- (instancetype)init {
    if (self = [super init]) {
        _regCheckNum = -1;
        _factCheckNum = -1;
        _regPosLO = -1;
        _regPosLA = -1;
    }
    return self;
}


// -1未检，0签到，1在检，2延期，3完成，9已出报告和健康证
+ (NSString *)getTestStatus:(NSString *)testStatus
{
    NSInteger stauts = [testStatus integerValue];
    NSString *test;
    switch (stauts) {
        case -1:{
            test = @"待检";
            break;
        }
        case 0:{
            test = @"已签到";
            break;
        }
        case 1:{
            test = @"检查中";
            break;
        }
        case 2:{
            test = @"延期";
            break;
        }
        case 3:{
            test = @"已完成";
            break;
        }
        case 9:{
            test = @"已出报告和健康证";
            break;
        }
        default:{
            test = @"暂无信息";
            break;
        }
    }
    return test;
}

@end
