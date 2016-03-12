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
            test = @"未检查";
            break;
        }
        case 0:{
            test = @"";
            break;
        }
        case 1:{
            test = @"";
            break;
        }
        case 2:{
            test = @"";
            break;
        }
        case 3:{
            test = @"完成体检";
            break;
        }
        case 4:{
            test = @"已出健康证";
        }
        case 9:{
            test = @"";
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
