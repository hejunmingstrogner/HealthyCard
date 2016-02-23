//
//  CloudAppointmentCompanyViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudAppointmentCompanyViewController.h"

@implementation CloudAppointmentCompanyViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
//    UIView* bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.view.mas_top).with.offset(SCREEN_HEIGHT-PXFIT_HEIGHT(136)-kNavigationBarHeight);
//        make.height.mas_equalTo(PXFIT_HEIGHT(136));
//    }];
//    
//    UIButton* appointmentBtn = [UIButton buttonWithTitle:@"预 约"
//                                                    font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Button_Size)]
//                                               textColor:MO_RGBCOLOR(70, 180, 240)
//                                         backgroundColor:[UIColor whiteColor]];
//    appointmentBtn.layer.cornerRadius = 5;
//    appointmentBtn.layer.borderWidth = 2;
//    appointmentBtn.layer.borderColor = MO_RGBCOLOR(70, 180, 240).CGColor;
//    [appointmentBtn addTarget:self action:@selector(appointmentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:appointmentBtn];
//    [appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(bottomView);
//        make.left.mas_equalTo(bottomView).with.offset(PXFIT_WIDTH(24));
//        make.width.mas_equalTo(SCREEN_WIDTH-2*PXFIT_WIDTH(24));
//        make.top.mas_equalTo(bottomView).with.offset(PXFIT_HEIGHT(20));
//        make.bottom.mas_equalTo(bottomView).with.offset(-PXFIT_HEIGHT(20));
//    }];
//    
//    UIScrollView* scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor = MO_RGBCOLOR(250, 250, 250);
//    [self.view addSubview:scrollView];
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.and.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(bottomView.mas_top);
//    }];
//    
//    
//    UIView* containerView = [[UIView alloc] init];
//    [scrollView addSubview:containerView];
//    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scrollView);
//        make.width.equalTo(scrollView);
//    }];
//    
//    
//    UITableView* baseInfoTableView = [[UITableView alloc] init];
//    baseInfoTableView.delegate = self;
//    baseInfoTableView.dataSource = self;
//    baseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    baseInfoTableView.separatorColor = [UIColor colorWithRGBHex:0xe8e8e8];
//    baseInfoTableView.layer.borderWidth = 1;
//    baseInfoTableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
//    baseInfoTableView.layer.cornerRadius = 10.0f;
//    baseInfoTableView.scrollEnabled = NO;
//    [baseInfoTableView registerClass:[BaseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BaseInfoTableViewCell class])];
//    [containerView addSubview:baseInfoTableView];
//    [baseInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(containerView).with.offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH-20);
//        make.height.mas_equalTo(PXFIT_HEIGHT(96)*3);
//    }];
//    
//    
//    _healthyCertificateView = [[HealthyCertificateView alloc] init];
//    _healthyCertificateView.layer.cornerRadius = 10;
//    _healthyCertificateView.layer.borderColor = MO_RGBCOLOR(0, 168, 234).CGColor;
//    _healthyCertificateView.layer.borderWidth = 1;
//    [containerView addSubview:_healthyCertificateView];
//    [_healthyCertificateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(containerView).with.offset(10);
//        // make.left.right.mas_equalTo(containerView);
//        make.top.mas_equalTo(baseInfoTableView.mas_bottom).with.offset(10);
//        make.width.mas_equalTo(SCREEN_WIDTH-20);
//        make.height.mas_equalTo(PXFIT_HEIGHT(460));
//    }];
//    
//    
//    _appointmentInfoView = [[AppointmentInfoView alloc] init];
//    [containerView addSubview:_appointmentInfoView];
//    [_appointmentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(containerView);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.top.mas_equalTo(_healthyCertificateView.mas_bottom).with.offset(10);
//    }];
//    
//    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_appointmentInfoView.mas_bottom);
//    }];
}

@end
