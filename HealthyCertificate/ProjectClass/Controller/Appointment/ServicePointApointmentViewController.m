//
//  ServicePointApointmentViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServicePointApointmentViewController.h"

#import "Constants.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "NSDate+Custom.h"
#import "UIButton+Easy.h"
#import "UILabel+Easy.h"
#import "UIButton+HitTest.h"

#import <Masonry.h>

#import "HCBackgroundColorButton.h"

#import "ServicePointCell.h"
#import "ServersPositionAnnotionsModel.h"

#import "TemperaryServicePDeViewController.h"
#import "ServicePointDetailViewController.h"
#import "CloudAppointmentViewController.h"
#import "CloudAppointmentCompanyViewController.h"
#import "OutCheckSiteHeaderView.h"



@interface ServicePointApointmentViewController()<UITableViewDataSource,UITableViewDelegate>
{}
@end


@implementation ServicePointApointmentViewController
{
    BOOL            _isOurcheckSite;
}

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#define Button_Size 24

#pragma mark - Life Circle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
    if (_serverPointList.count == 0){
        UILabel* label = [UILabel labelWithText:@"    您附近没有合适的上门体检服务点,请通过快速预约告之您的体检位置和体检时间,我们会及时安排体检车上门为您体检办证!"
                                           font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(26)]
                                      textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view).with.offset(10);
            make.right.mas_equalTo(self.view).with.offset(-10);
        }];
        
    }else{
        UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _isOurcheckSite = ((ServersPositionAnnotionsModel*)_serverPointList[0]).type == 0 ? NO :YES;
        
        [self.view addSubview:tableView];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[ServicePointCell class] forCellReuseIdentifier:NSStringFromClass([ServicePointCell class])];
        tableView.backgroundColor = MO_RGBCOLOR(250, 250, 250);
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.bottom.equalTo(self.view).with.offset(_serviceType == ServicePointApointmentViewControllerType_Customer?0:-PXFIT_HEIGHT(136));
            make.top.equalTo(self.view).with.offset(kStatusBarHeight+kNavigationBarHeight);
        }];
    }
    
    if (_serviceType == ServicePointApointmentViewControllerType_Cloud){
        UIView* bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(PXFIT_HEIGHT(136));
        }];
        
        HCBackgroundColorButton* appointmentBtn = [[HCBackgroundColorButton alloc] init];
        [appointmentBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
        [appointmentBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
        [appointmentBtn setTitle:@"自建体检点" forState:UIControlStateNormal];
        appointmentBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Button_Size)];
        appointmentBtn.layer.cornerRadius = 5;
        [appointmentBtn addTarget:self action:@selector(confrimBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView addSubview:appointmentBtn];
        [appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bottomView).insets(UIEdgeInsetsMake(PXFIT_WIDTH(24), PXFIT_HEIGHT(20), PXFIT_HEIGHT(20), PXFIT_WIDTH(24)));
        }];
    }
}

- (void)initNavgation
{
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"服务点列表";
}

#pragma mark - Action
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confrimBtnClicked:(UIButton*)sender{
    CloudAppointmentCompanyViewController* companyCloudAppointment = [[CloudAppointmentCompanyViewController alloc] init];
    companyCloudAppointment.location = _location;
    companyCloudAppointment.centerCoordinate = _centerCoordinate;
    companyCloudAppointment.isCustomerServerPoint = YES;
    [self.navigationController pushViewController:companyCloudAppointment animated:YES];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _serverPointList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServicePointCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ServicePointCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithRGBHex:0xe0e0e0].CGColor;
    __weak typeof (self) wself = self;
    cell.serviceAppointmentBtnClickedBlock = ^(){
        __strong typeof (self) sself = wself;
        ServersPositionAnnotionsModel* serverPoint = (ServersPositionAnnotionsModel*)sself->_serverPointList[indexPath.section];
        
        if (GetUserType == 1){
            CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
            cloudAppoint.sercersPositionInfo = serverPoint;
            cloudAppoint.isCustomerServerPoint = NO;
            [wself.navigationController pushViewController:cloudAppoint animated:YES];
        }else{
            CloudAppointmentCompanyViewController* companyCloudAppointment = [[CloudAppointmentCompanyViewController alloc] init];
            companyCloudAppointment.sercersPositionInfo = serverPoint;
            companyCloudAppointment.isCustomerServerPoint = NO;
            [wself.navigationController pushViewController:companyCloudAppointment animated:YES];
        }
    };
    cell.servicePointCellPhoneNumBtnBlock = ^(NSString* phoneNumber){
        NSString* urlNumberStr = [NSString stringWithFormat:@"tel://%@", phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlNumberStr]];
    };
    
    ServersPositionAnnotionsModel* serverPoint = (ServersPositionAnnotionsModel*)_serverPointList[indexPath.section];
    cell.servicePoint = serverPoint;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(294);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PXFIT_HEIGHT(20) + (_isOurcheckSite?PXFIT_HEIGHT(50):0);
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = MO_RGBCOLOR(250, 250, 250);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isOurcheckSite == NO){
        return nil;
    }
    UITableViewHeaderFooterView* containerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!containerView){
        containerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerview"];
        ServersPositionAnnotionsModel* serverPoint = (ServersPositionAnnotionsModel*)_serverPointList[section];
        OutCheckSiteHeaderView* outCheckSiteHeaderView = [[OutCheckSiteHeaderView alloc] init];
        outCheckSiteHeaderView.countPeople = serverPoint.maxNum - serverPoint.oppointmentNum;
        outCheckSiteHeaderView.appointmentCount = serverPoint.oppointmentNum;
        [containerView addSubview:outCheckSiteHeaderView];
        [outCheckSiteHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(containerView);
            make.height.mas_equalTo(PXFIT_HEIGHT(50));
        }];
    }
    return containerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_serverPointList == nil || _serverPointList.count == 0){
        return;
    }
    //服务点详情
    ServersPositionAnnotionsModel* servicePositionAnnotionsModel = (ServersPositionAnnotionsModel*)_serverPointList[indexPath.section];
    if (servicePositionAnnotionsModel.type == 0){
        //固定服务点
        ServicePointDetailViewController* fixedServicePointVC = [[ServicePointDetailViewController alloc] init];
        fixedServicePointVC.serverPositionItem = servicePositionAnnotionsModel;
        [self.navigationController pushViewController:fixedServicePointVC animated:YES];
    }else{
        //移动服务点
        TemperaryServicePDeViewController* movingServicePointVC = [[TemperaryServicePDeViewController alloc] init];
        movingServicePointVC.servicePositionItem = servicePositionAnnotionsModel;
        [self.navigationController pushViewController:movingServicePointVC animated:YES];
    }
}

@end
