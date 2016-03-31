//
//  PersonalHealthyCHistoryVC.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PersonalHealthyCHistoryVC.h"

#import "Constants.h"

#import "CloudAppointmentDateVC.h"
#import "EditInfoViewController.h"
#import "WorkTypeViewController.h"
#import "QRController.h"

#import "TakePhoto.h"
#import "HttpNetworkManager.h"
#import "PositionUtil.h"

#import "NSDate+Custom.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"
#import <UIImageView+WebCache.h>

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation PersonalHealthyCHistoryVC

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
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    UIButton* shareBtn = [UIButton buttonWithTitle:@"分享"
                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                   backgroundColor:[UIColor clearColor]];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)shareBtnClicked:(UIButton*)sender
{
    QRController* qrController = [[QRController alloc] init];
    qrController.qrContent = [NSString stringWithFormat:@"http://webserver.zeekstar.com/webserver/weixin/person_checkreport.jsp?checkCode=%@", _customerTestInfo.checkCode];
    qrController.infoStr = @"健康证防伪信息查看，有您的体检数据详情。分享请慎重！";
    qrController.shareText = @"健康证防伪信息查看，有您的体检数据详情。分享请慎重！";
    [self.navigationController pushViewController:qrController animated:YES];
}

// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCustomerTestInfo:(CustomerTest *)customerTestInfo
{
    _customerTestInfo = customerTestInfo;
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    _baseBgScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_baseBgScrollView];
    _baseBgScrollView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.9];
    _baseBgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, PXFIT_HEIGHT(470) + 200 + 30);

    _healthCertificateView = [[HealthyCertificateView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, PXFIT_HEIGHT(470))];
    [_baseBgScrollView addSubview:_healthCertificateView];
    _healthCertificateView.layer.masksToBounds = YES;
    _healthCertificateView.layer.cornerRadius = 10;
    _orderinforView = [[HealthyCertificateOrderInfoView alloc]initWithFrame:CGRectMake(10, 10+ PXFIT_HEIGHT(470) + 10, self.view.frame.size.width - 20, 200)];
    [_baseBgScrollView addSubview:_orderinforView];
}

- (CGFloat)labelheigh:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:15];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+15;
    return fmaxf(he, 20);
}

- (void)initData
{
    _healthCertificateView.customerTest = _customerTestInfo;
    _orderinforView.cutomerTest = _customerTestInfo;
}
@end
