//
//  ServicePointDetailViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServicePointDetailViewController.h"
#import "ServicePositionCarHeadTableViewCell.h"
#import <Masonry.h>
#import "CloudAppointmentViewController.h"
#import "ServicePositionDetialCellItem.h"
#import "CloudAppointmentCompanyViewController.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"
#import "Constants.h"
#import "NSDate+Custom.h"
#import "RzAlertView.h"
#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationService.h>
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface ServicePointDetailViewController()<BMKLocationServiceDelegate, BMKMapViewDelegate>
{
    BMKMapView  *_mapView;
    BMKLocationService *_locationServer;
}
@end

@implementation ServicePointDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initData];

    [self initSubViews];
}

- (void)initNavgation
{
    self.title = @"服务点信息";
    
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
    NSArray *arry0 = [NSArray arrayWithObject:_serverPositionItem];

    NSString *str = @"成都信息工程大学（Chengdu University of Information Technology）简称“成信大”，由中国气象局和四川省人民政府共建，入选中国首批“卓越工程师教育培养计划”、“中西部高校基础能力建设工程”、“2011计划”，为国际CDIO组织正式成员、中国气象人才培养联盟成员、全国CDIO工程教育联盟常务理事单位，是第一所为中国人民解放军火箭军部队培养国防生的一般本科院校，是以信息学科和大气学科为重点，学科交叉为特色，工学、理学、管理学为主要学科门类的省属重点大学。";
    if(_serverPositionItem.introduce.length == 0){
        _serverPositionItem.introduce = str;
    }
    ServicePositionDetialCellItem *item10 = [[ServicePositionDetialCellItem alloc]initWithTitle:_serverPositionItem.introduce detialText:@"" flag:1];
    NSArray *arry1 = [NSArray arrayWithObjects:item10, nil];

    ServicePositionDetialCellItem *item21 = [[ServicePositionDetialCellItem alloc]initWithTitle:@"地址:" detialText:_serverPositionItem.address];
    ServicePositionDetialCellItem *item22 = [[ServicePositionDetialCellItem alloc]initWithTitle:@"电话:" detialText:_serverPositionItem.leaderPhone];

    NSArray *arry2 = [NSArray arrayWithObjects:item21, item22, nil];

    _inforArray = [[NSMutableArray alloc]initWithObjects:arry0, arry1, arry2, nil];
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    _orderBtn = [[WZFlashButton alloc] init];
    _orderBtn.backgroundColor = [UIColor colorWithRGBHex:HC_Base_Blue];
    _orderBtn.flashColor = [UIColor colorWithRGBHex:HC_Base_Blue_Pressed];
    [_orderBtn setText:@"预约" withTextColor:[UIColor whiteColor]];
    [self.view addSubview:_orderBtn];

    [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    _orderBtn.layer.masksToBounds = YES;
    _orderBtn.layer.cornerRadius = 5;
    __weak typeof(self) wself = self;
    _orderBtn.clickBlock = ^(){
        [wself orderBtnClicked];
    };
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200 - 60)];
    _mapView.zoomLevel = 14;
    _mapView.compassPosition = CGPointMake([UIScreen mainScreen].bounds.size.width - 50, 10);
    [self.view addSubview:_mapView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_mapView.mas_top).offset(-10);
    }];
    // 设置显示服务点信息
    [self addServiersPositionAnno];

    // 用户设置地图滑动的按钮
    CustomButton* scrollBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_mapView addSubview:scrollBtn];
    [scrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mapView);
        make.centerX.equalTo(_mapView);
        make.width.height.mas_equalTo(40);
    }];
    scrollBtn.tag = 1;
    [scrollBtn setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9]];
    [scrollBtn setBackgroundImage:[UIImage imageNamed:@"goDown"] forState:UIControlStateNormal];
    [scrollBtn addTarget:self action:@selector(setNewMapFrame:) forControlEvents:UIControlEventTouchUpInside];}

- (void)setNewMapFrame:(UIButton *)sender
{
    sender.enabled = NO;
    if (sender.tag == 1) { // 下缩
        [UIView animateWithDuration:0.3 animations:^{
            _mapView.frame = CGRectMake(0, self.view.frame.size.height - 170 - 60, self.view.frame.size.width, 170);
        }];
        sender.tag = 2;
        [sender setBackgroundImage:[UIImage imageNamed:@"goUp"] forState:UIControlStateNormal];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            _mapView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200 - 60);
        }];
        sender.tag = 1;
        [sender setBackgroundImage:[UIImage imageNamed:@"goDown"] forState:UIControlStateNormal];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _inforArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_inforArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _inforArray.count - 1) {
        return 10;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    else if (indexPath.section == 1){
        return fmaxf(44, [self cellheight:_serverPositionItem.introduce]);
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ServicePositionCarHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        if (!cell) {
            cell = [[ServicePositionCarHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carcell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setCellItem:_serverPositionItem];
        return cell;
    }
    else {
        if (((ServicePositionDetialCellItem *)_inforArray[indexPath.section][indexPath.row]).flag == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
                cell.textLabel.numberOfLines = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.font = [UIFont fontWithType:0 size:15];
                cell.detailTextLabel.font = [UIFont fontWithType:0 size:15];
            }
            cell.textLabel.text = ((ServicePositionDetialCellItem *)_inforArray[indexPath.section][indexPath.row]).titleText;
            cell.detailTextLabel.text = ((ServicePositionDetialCellItem *)_inforArray[indexPath.section][indexPath.row]).detialText;

            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell.textLabel.textColor = [UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont fontWithType:0 size:15];
                cell.textLabel.numberOfLines = 0;
            }
            cell.textLabel.text = ((ServicePositionDetialCellItem *)_inforArray[indexPath.section][indexPath.row]).titleText;
            return cell;
        }
    }
}

- (CGFloat)cellheight:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:17];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+10;
    return he;
}

- (void)orderBtnClicked
{
    if (GetUserType == 1){
        //个人
        CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
        cloudAppoint.sercersPositionInfo = _serverPositionItem;
        if (_serverPositionItem.type == 1){
            //临时服务点
            cloudAppoint.appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",
                                               [NSDate getYear_Month_DayByDate:_serverPositionItem.startTime/1000],
                                               [NSDate getHour_MinuteByDate:_serverPositionItem.startTime/1000],
                                               [NSDate getHour_MinuteByDate:_serverPositionItem.endTime/1000]];
        }else{
            cloudAppoint.appointmentDateStr = [NSString stringWithFormat:@"工作日(%@~%@)",
                                               [NSDate getHour_MinuteByDate:_serverPositionItem.startTime/1000],
                                               [NSDate getHour_MinuteByDate:_serverPositionItem.endTime/1000]];
        }
        cloudAppoint.isCustomerServerPoint = NO; //如果是基于现有的服务点预约
        [self.navigationController pushViewController:cloudAppoint animated:YES];
    }else{
        //单位
        CloudAppointmentCompanyViewController* companyCloudAppointment = [[CloudAppointmentCompanyViewController alloc] init];
        companyCloudAppointment.sercersPositionInfo = _serverPositionItem;
        if (_serverPositionItem.type == 1){
            //临时服务点
            companyCloudAppointment.appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",
                                                          [NSDate getYear_Month_DayByDate:_serverPositionItem.startTime/1000],
                                                          [NSDate getHour_MinuteByDate:_serverPositionItem.startTime/1000],
                                                          [NSDate getHour_MinuteByDate:_serverPositionItem.endTime/1000]];
        }else{
            companyCloudAppointment.appointmentDateStr = [NSString stringWithFormat:@"工作日(%@~%@)",
                                                          [NSDate getHour_MinuteByDate:_serverPositionItem.startTime/1000],
                                                          [NSDate getHour_MinuteByDate:_serverPositionItem.endTime/1000]];
        }
        companyCloudAppointment.isCustomerServerPoint = NO; //如果是基于现有的服务点预约
        [self.navigationController pushViewController:companyCloudAppointment animated:YES];
    }
}

#pragma mark -地图相关
- (void)addServiersPositionAnno
{
    _locationServer = [[BMKLocationService alloc]init];
    _locationServer.delegate = self;
    [_locationServer startUserLocationService];

    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    //    _mapView.userTrackingMode = BMKUserTrackingModeFollow;

    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_serverPositionItem.positionLa, _serverPositionItem.positionLo);
    [_mapView setCenterCoordinate:coor animated:YES];

    BMKPointAnnotation *anno = [[BMKPointAnnotation alloc]init];
    anno.coordinate = coor;
    anno.title = _serverPositionItem.address;
    [_mapView addAnnotation:anno];
}
#pragma mark -地图相关的delegate、
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    NSLog(@"finish");
}

@end
