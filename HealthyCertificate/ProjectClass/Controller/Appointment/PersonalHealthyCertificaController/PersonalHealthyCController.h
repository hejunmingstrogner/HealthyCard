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

@interface PersonalHealthyCController : UIViewController

@property (nonatomic, strong) HealthyCertificateOrderInfoView *orderinforView;      // 预约信息界面view

@property (nonatomic, strong) HealthyCertificateView         *healthCertificateView;// 健康证界面view

@property (nonatomic, strong) UIScrollView                   *baseBgScrollView;

@property (nonatomic, strong) UILabel                        *introduceLabel;   // 文字说明label 

@property (nonatomic, strong) CustomerTest                   *customerTestInfo;

@end
