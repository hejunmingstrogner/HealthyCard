//
//  PersonalHealthyCHistoryVC.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//


// 用户健康证 （历史记录）
#import <UIKit/UIKit.h>
#import "HealthyCertificateOrderInfoView.h"
#import "HealthyCertificateView.h"
#import "CustomerTest.h"
#import "SelectAddressViewController.h"
/**
 *  用户健康证 （历史记录）
 */
@interface PersonalHealthyCHistoryVC : UIViewController

@property (nonatomic, strong) HealthyCertificateOrderInfoView *orderinforView;      // 预约信息界面view

@property (nonatomic, strong) HealthyCertificateView         *healthCertificateView;// 健康证界面view

@property (nonatomic, strong) UIScrollView                   *baseBgScrollView;

@property (nonatomic, strong) CustomerTest                   *customerTestInfo;


- (void)setCustomerTestInfo:(CustomerTest *)customerTestInfo;

@end
