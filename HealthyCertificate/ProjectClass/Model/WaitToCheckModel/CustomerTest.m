//
//  CustomerTest.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerTest.h"

@implementation CustomerTest
- (instancetype)init
{
    if (self = [super init]) {
        _payMoney = 0;
        _checkType = -1;
    }
    return self;
}

-(ServersPositionAnnotionsModel*)servicePoint{
    if (_servicePoint == nil){
        _payMoney = 0;
        _checkType = -1;
        _servicePoint = [[ServersPositionAnnotionsModel alloc] init];
    }
    
    return _servicePoint;
}

 // -1未检，0签到，1在检，2延期，3完成，4已通过总检确认，5已打印体检卡，6已打印条码，9已出报告和健康证
- (NSArray *)getTestStatusArrayWithTestStatus:(NSString *)teststatus
{
    NSArray *aarry;
    NSInteger test = [teststatus integerValue];
    switch (test) {
        case -1:{
            aarry = @[@" ", @"未检", @"签到"];
            break;
        }
        case 0:{
            aarry = @[@"未检", @"签到", @"在检"];
            break;
        }
        case 1:{
            aarry = @[@"签到", @"在检", @"延期"];
            break;
        }
        case 2:{
            aarry = @[@"在检", @"延期", @"完成"];
            break;
        }
        case 3:{
            aarry = @[@"延期", @"完成", @"已通过总检确认"];
            break;
        }
        case 4:{
            aarry = @[@"完成", @"已通过总检确认", @"已打印体检卡"];
            break;
        }
        case 5:{
            aarry = @[@"已通过总检确认", @"已打印体检卡", @"6已打印条码"];
            break;
        }
        case 6:{
            aarry = @[@"已打印体检卡", @"6已打印条码", @"已出报告和健康证"];
            break;
        }
        case 9:{
            aarry = @[@"6已打印条码", @"已出报告和健康证", @" "];
            break;
        }
        default:
            aarry = @[@" ", @" ", @" "];
            break;
    }
    return aarry;
}

@end
