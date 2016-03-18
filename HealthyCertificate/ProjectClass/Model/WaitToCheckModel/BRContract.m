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
        _regCheckNum = 0;
        _factCheckNum = 0;
        _regPosLO = -1;
        _regPosLA = -1;
    }
    return self;
}


// -1所有员工未开始检查，3所有员工完成体检，4所有员工已出健康证
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
            break;
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
