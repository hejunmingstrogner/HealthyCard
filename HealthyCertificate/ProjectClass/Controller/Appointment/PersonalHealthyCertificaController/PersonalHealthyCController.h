//
//  PersonalHealthyCController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

// 用户健康证 （我的健康证）
#import <UIKit/UIKit.h>
#import "HealthyCertificateOrderInfoView.h"
#import "HealthyCertificateView.h"
#import "CustomerTest.h"
#import "SelectAddressViewController.h"
#import "HCWheelView.h"
@interface PersonalHealthyCController : UIViewController<HealthyCertificateViewDelegate, HCWheelViewDelegate>
{
    HCWheelView *wheelView;
}
@property (nonatomic, strong) HealthyCertificateOrderInfoView *orderinforView;      // 预约信息界面view

@property (nonatomic, strong) HealthyCertificateView         *healthCertificateView;// 健康证界面view

@property (nonatomic, strong) UIScrollView                   *baseBgScrollView;

@property (nonatomic, strong) CustomerTest                   *customerTestInfo;

@property (nonatomic, strong) UIButton                       *leftBtn;          // 左侧按钮
@property (nonatomic, strong) UIButton                       *centerBtn;   // 中间按钮
@property (nonatomic, strong) UIButton                       *rightBtn;      // 右侧按钮


@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) double posLo;
@property (nonatomic, assign) double posLa;
@property (nonatomic, strong) NSString *linkerPhone;
@property (nonatomic, assign) long long regbegindate;
@property (nonatomic, assign) long long regenddate;
- (void)setCustomerTestInfo:(CustomerTest *)customerTestInfo;

typedef void(^resultBlock)(BOOL ischanged, NSIndexPath *indexpath); // 回调是否修改了数据
@property (nonatomic, assign) NSIndexPath *indexPath;               // 当前数据的indexpath
@property (nonatomic, strong) resultBlock resultblock;              // 回调
- (void)changedInformationWithResultBlock:(resultBlock)blcok;       // 修改了数据则需要刷新的回调

@end
