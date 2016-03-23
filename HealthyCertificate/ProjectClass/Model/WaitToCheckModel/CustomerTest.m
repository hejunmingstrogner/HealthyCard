//
//  CustomerTest.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerTest.h"

@implementation CustomerTestStatusItem

@end


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

 // -1待检，0签到，1在检，2延期，3完成，4已通过总检确认，5已打印体检卡，6已打印条码，9已出报告和健康证
- (NSArray *)getTestStatusArrayWithTestStatus:(NSString *)teststatus
{
    NSArray *aarry;
    NSInteger test = [teststatus integerValue];
    switch (test) {
        case -1:{
            aarry = @[@" ", @"待检", @"签到"];
            break;
        }
        case 0:{
            aarry = @[@"待检", @"签到", @"在检"];
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

// 新的获取方法
// 待检（状态值-1、0、5、6）、在检（状态值1、2）、待出征（状态值3、4）、已出证（状态值9）、已完成（状态值10）
- (CustomerTestStatusItem *)getTestStatusWithTestStatus:(NSString *)testatus
{
    NSInteger flag = [testatus integerValue];
    CustomerTestStatusItem *item = [[CustomerTestStatusItem alloc]init];
    switch (flag) {
        case -1:
        case 0:
        case 5:
        case 6:{
            item.leftText = @"待检";
            item.centerText = @"在检";
            item.rigthText = @"待出证";
            item.status = LEFT_STATUS;
            item.warmingText = @"请于XXX年月日到XXX地址进行体检。离拿到健康证还有XX天。如有疑问，请联系027-82867046";
            break;
        }
        case 1:
        case 2:{
            item.leftText = @"待检";
            item.centerText = @"在检";
            item.rigthText = @"待出证";
            item.status = CENTER_STATUS;
            item.warmingText = @"您的健康证体检约XX小时之后完成。离拿到健康证还有XX天。请联系027-82867046。";
            break;
        }
        case 3:
        case 4:{
            item.leftText = @"在检";
            item.centerText = @"待出证";
            item.rigthText = @"已出证";
            item.status = CENTER_STATUS;
            item.warmingText = @"您的健康证体检结果分析约XX天后完成。离拿到健康证还有XX天。请联系027-82867046。";
            break;
        }
        case 9:{
            item.leftText = @"待出证";
            item.centerText = @"已出证";
            item.rigthText = @"已完成";
            item.status = CENTER_STATUS;
            item.warmingText = @"您的健康证正在向您飞来。离拿到健康证还有XX天。请联系027-82867046。";
            break;
        }
        case 10:{
            item.leftText = @"待出证";
            item.centerText = @"已出证";
            item.rigthText = @"已完成";
            item.status = RIGHT_STATUS;
            item.warmingText = @"谢谢您的信任。如果服务不好，吐槽一百次。如果服务好，点赞一次。请联系027-82867046。";
            break;
        }
        default:
            item.leftText = @" ";
            item.centerText = @" ";
            item.rigthText = @" ";
            item.status = NONE_STATUS;
            item.warmingText = @"";
            break;
    }
    return item;
}

@end
