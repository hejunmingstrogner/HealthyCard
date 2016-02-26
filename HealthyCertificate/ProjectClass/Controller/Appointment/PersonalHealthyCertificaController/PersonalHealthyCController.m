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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    _baseBgScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_baseBgScrollView];
    _baseBgScrollView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.9];
    _baseBgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, PXFIT_HEIGHT(460) + 200 + 200);

    _healthCertificateView = [[HealthyCertificateView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, PXFIT_HEIGHT(460))];
    [_baseBgScrollView addSubview:_healthCertificateView];
    _healthCertificateView.layer.masksToBounds = YES;
    _healthCertificateView.delegate = self;
    _healthCertificateView.layer.cornerRadius = 10;

    _orderinforView = [[HealthyCertificateOrderInfoView alloc]initWithFrame:CGRectMake(10, 10+ PXFIT_HEIGHT(460) + 20, self.view.frame.size.width - 20, 200)];
    [_baseBgScrollView addSubview:_orderinforView];

    _introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+ PXFIT_HEIGHT(460) + 20 + 220, self.view.frame.size.width - 20, 50)];
    [_baseBgScrollView addSubview:_introduceLabel];
    _introduceLabel.numberOfLines = 0;
}

- (void)initData
{
    __weak PersonalHealthyCController *weakself = self;
    _healthCertificateView.customerTest = _customerTestInfo;
    _orderinforView.cutomerTest = _customerTestInfo;
    [_orderinforView.addressBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        // 点击地址搜索
        SelectAddressViewController *addressselect = [[SelectAddressViewController alloc]init];
        [addressselect getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
            NSLog(@"address: %@", address);
        }];
        [weakself.navigationController pushViewController:addressselect animated:YES];
    }];
    [_orderinforView.timeBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        // 点击时间
        NSLog(@"点击时间");
    }];
    [_orderinforView.phoneBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        // 点击电话
        NSLog(@"点击电话");
    }];
}
//点击姓名
-(void)nameBtnClicked:(NSString*)name
{
    NSLog(@"点击姓名");
}
//点击性别
-(void)sexBtnClicked:(NSString*)gender{
    NSLog(@"点击性别");
}
//点击行业
-(void)industryBtnClicked:(NSString*)industry{
    NSLog(@"点击行业");
}
//点击身份证
-(void)idCardBtnClicked:(NSString*)idCard
{
    NSLog(@"点击身份证");
}

@end
