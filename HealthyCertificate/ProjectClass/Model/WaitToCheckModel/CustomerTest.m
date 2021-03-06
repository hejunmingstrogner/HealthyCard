//
//  CustomerTest.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CustomerTest.h"
#import "HttpNetworkManager.h"
#import "RzAlertView.h"

#import "NSDate+Custom.h"

@implementation CustomerTestStatusItem

@end


@implementation CustomerTest
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
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
- (CustomerTestStatusItem *)getTestStatusItem
{
    NSInteger flag = [self.testStatus integerValue];
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
            
            if (self.servicePoint == nil){
                //单位统一预约
                NSDateComponents* cp = [NSDate getInternalDateFrom:[NSDate date]
                                              To:[[NSDate alloc] initWithTimeIntervalSince1970:self.regTime/1000]];
                item.warmingText = [NSString stringWithFormat:@"   离您体检还有%ld天%ld小时,请于%@到%@按时进行办证体检，以免影响您的工作!", cp.day, cp.hour, [NSDate converLongLongToChineseStringDate:self.regTime/1000], self.regPosAddr];
            }else{
                //服务点预约
                NSDateComponents* cp;
                if (_servicePoint.type == 0){
                    //固定
                    cp = [NSDate getInternalDateFrom:[NSDate date]
                                                  To:[[NSDate alloc] initWithTimeIntervalSince1970:self.regTime/1000]];
                    item.warmingText = [NSString stringWithFormat:@"   离您体检还有%ld天%ld小时,请于%@到%@按时进行办证体检，以免影响您的工作!", cp.day, cp.hour, [NSDate converLongLongToChineseStringDate:self.regTime/1000], self.servicePoint.address];
                }else{
                    //移动
                    cp = [NSDate getInternalDateFrom:[NSDate date]
                                                  To:[[NSDate alloc] initWithTimeIntervalSince1970:self.servicePoint.startTime/1000]];
                    item.warmingText = [NSString stringWithFormat:@"   离您体检还有%ld天%ld小时,请于%@到%@按时进行办证体检，以免影响您的工作!", cp.day, cp.hour, [NSDate converLongLongToChineseStringDate:self.servicePoint.startTime/1000], self.servicePoint.address];
                }
            }
            break;
        }
        case 1:
        case 2:{
            item.leftText = @"待检";
            item.centerText = @"在检";
            item.rigthText = @"待出证";
            item.status = CENTER_STATUS;
            if (self.servicePoint.type == 1){
                item.warmingText = [NSString stringWithFormat:@"请在%@完成抽血等各项检查，并到体检车（车牌号：%@，%@）进行胸透。离拿到健康证还有7天。", self.servicePoint.address,self.servicePoint.brOutCheckArrange.plateNo, self.servicePoint.brOutCheckArrange.vehicleInfo];
            }else{
                item.warmingText = [NSString stringWithFormat:@"请到指定地点完成各项检查。离拿到健康证还有7天。"];
            }
            break;
        }
        case 3:
        case 4:{
            item.leftText = @"在检";
            item.centerText = @"待出证";
            item.rigthText = @"已出证";
            item.status = CENTER_STATUS; //7-（当日-体检确认日
            NSInteger dateNum = [NSDate getInternalDateFrom:[NSDate formatDateFromChineseString:[[NSDate date] formatDateToChineseString]] To:[[NSDate alloc] initWithTimeIntervalSince1970:self.affirmdate/1000]].day;
            item.warmingText = [NSString stringWithFormat:@"您已完成体检，离拿到健康证还有约%ld天。", 7 - dateNum];
            break;
        }
        case 9:{
            item.leftText = @"待出证";
            item.centerText = @"已出证";
            item.rigthText = @"已完成";
            item.status = CENTER_STATUS;
            NSInteger dateNum = [NSDate getInternalDateFrom:[NSDate formatDateFromChineseString:[[NSDate date] formatDateToChineseString]] To:[[NSDate alloc] initWithTimeIntervalSince1970:self.affirmdate/1000]].day;
            item.warmingText = [NSString stringWithFormat:@"您的健康证正在向您飞来的途中，离拿到健康证还有约%ld天。", 7 - dateNum];
            break;
        }
        case 10:{
            item.leftText = @"待出证";
            item.centerText = @"已出证";
            item.rigthText = @"已完成";
            item.status = RIGHT_STATUS;
            item.warmingText = @"有什么想吐槽的？";
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

// 是否可以取消订单
- (BOOL)canCancelTheOrder
{
    if (self.payMoney > 0) {
        return NO;
    }
    switch ([self.testStatus integerValue]) {
        case -1:
        case 0:
        case 5:
        case 6:
            return YES;
        default:
            return NO;
    }
}

// 获得应付金额
- (void)getNeedMoneyWhenPayFor
{
    // 设置价格
    if (_needMoney > 0) {
        return;
    }
    // 如果已经付款，或者现在不能付款，则不需要价格
    if (![self isNeedToPay]) {
        _needMoney = 0;
        return;
    }
    // 获得单价
    [[HttpNetworkManager getInstance]getCustomerTestChargePriceWithCityName:_cityName checkType:nil resultBlcok:^(NSString *result, NSError *error) {
        if (!error) {
            _needMoney = [result floatValue];
        }
        else {
            _needMoney = 0;
        }
    }];
}

// 是否需要去付款 Yes:需要去付款   No,已经付款或者体检了，不需要去付款了
- (BOOL)isNeedToPay{
    if(self.payMoney > 0){
        return NO;
    }
    if (![self.testStatus isEqualToString:@"-1"]) {
        return NO;
    }
    return YES;
}

@end
