//
//  PersonalHealthyCController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PersonalHealthyCController.h"
#import "Constants.h"

@implementation PersonalHealthyCController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];

    [self initData];
}

- (void)initNavgation
{
    self.title = @"我的健康证";  // 车辆牌照
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initSubViews
{
    _baseBgScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_baseBgScrollView];
    _baseBgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, PXFIT_HEIGHT(460) + 200 + 200);

    _healthCertificateView = [[HealthyCertificateView alloc]init];
    [_baseBgScrollView addSubview:_healthCertificateView];
    [_healthCertificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_baseBgScrollView).offset(70);
        make.left.equalTo(_baseBgScrollView).offset(10);
        make.right.equalTo(_baseBgScrollView).offset(-10);
        make.height.mas_equalTo(PXFIT_HEIGHT(460));
    }];

    _orderinforView = [[HealthyCertificateOrderInfoView alloc]init];
    [_baseBgScrollView addSubview:_orderinforView];
    [_orderinforView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_healthCertificateView.mas_bottom).offset(20);
        make.left.right.equalTo(_healthCertificateView);
        make.height.mas_equalTo(200);
    }];

    _introduceLabel = [[UILabel alloc]init];
    [_baseBgScrollView addSubview:_introduceLabel];
    _introduceLabel.numberOfLines = 0;
    [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderinforView.mas_bottom).offset(20);
        make.right.left.equalTo(_orderinforView);
        make.height.mas_equalTo(50);
    }];
}

- (void)initData
{
    //_healthCertificateView.name
}
@end
