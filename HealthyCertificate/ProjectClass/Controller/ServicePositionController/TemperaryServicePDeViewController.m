//
//  TemperaryServicePDeViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "TemperaryServicePDeViewController.h"

#import "ServicePositionDetialCellItem.h"
#import <Masonry.h>
#import "ServicePositionCarHeadTableViewCell.h"
#import "CloudAppointmentViewController.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "Constants.h"
#import "CloudAppointmentCompanyViewController.h"
#import "NSDate+Custom.h"
#import "RzAlertView.h"
#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationService.h>
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface TemperaryServicePDeViewController()<UITableViewDelegate, UITableViewDataSource, BMKLocationServiceDelegate, BMKMapViewDelegate>
{
    BMKMapView  *_mapView;
    BMKLocationService *_locationServer;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *detialeInfoArray;

@end

@implementation TemperaryServicePDeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initData];

    [self initSubViews];
}

#pragma mark -地图相关
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    //_mapView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    //_mapView.delegate = nil;
}

#pragma mark -初始化相关
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
    NSMutableArray *arry = [NSMutableArray arrayWithObjects:@"1", nil];

    ServicePositionDetialCellItem *leader = [[ServicePositionDetialCellItem alloc]initWithTitle:@"体检顾问:" detialText:_servicePositionItem.brOutCheckArrange.leaderName];
    ServicePositionDetialCellItem *leadercaptain = [[ServicePositionDetialCellItem alloc]initWithTitle:@"体检组长:" detialText:_servicePositionItem.brOutCheckArrange.captainName];

     ServicePositionDetialCellItem *memberList = [[ServicePositionDetialCellItem alloc]initWithTitle:@"医护人员:" detialText:_servicePositionItem.brOutCheckArrange.memberList];

    NSMutableArray *arry1 = [NSMutableArray arrayWithObjects:leader, leadercaptain, memberList, nil];

    NSString *str = [NSString stringWithFormat:@"(%@)", _servicePositionItem.brOutCheckArrange.vehicleInfo];
    ServicePositionDetialCellItem *caeNo = [[ServicePositionDetialCellItem alloc]initWithTitle: _servicePositionItem.brOutCheckArrange.plateNo detialText:str];
    ServicePositionDetialCellItem *phone = [[ServicePositionDetialCellItem alloc]initWithTitle:_servicePositionItem.brOutCheckArrange.leaderPhone detialText:@"" flag:1];
    NSMutableArray *arry2 = [NSMutableArray arrayWithObjects:caeNo, phone, nil];

    _detialeInfoArray = [NSMutableArray arrayWithObjects:arry, arry1, arry2, nil];
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    _orderBtn = [[HCBackgroundColorButton alloc] init];
    [_orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
    [_orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
    [_orderBtn setTitle:@"预约" forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(orderBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderBtn];
    [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    _orderBtn.layer.masksToBounds = YES;
    _orderBtn.layer.cornerRadius = 5;

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
    CustomButton *scrollBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_mapView addSubview:scrollBtn];
    [scrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mapView);
        make.centerX.equalTo(_mapView);
        make.width.height.mas_equalTo(40);
    }];

    scrollBtn.tag = 1;
    [scrollBtn setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9]];
    [scrollBtn setBackgroundImage:[UIImage imageNamed:@"goDown"] forState:UIControlStateNormal];
    [scrollBtn addTarget:self action:@selector(setNewMapFrame:) forControlEvents:UIControlEventTouchUpInside];
}

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
    return _detialeInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_detialeInfoArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _detialeInfoArray.count - 1) {
        return 10;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    else if(indexPath.section == 1 || indexPath.section == 2){
        return 44;
    }
    else if (indexPath.section == 3){
        return fmaxf(44, [self cellheight:((ServicePositionDetialCellItem *)_detialeInfoArray[indexPath.section][indexPath.row]).titleText]);
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ServicePositionCarHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        if (!cell) {
            cell = [[ServicePositionCarHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carcell"];
        }
        [cell setCellItem:_servicePositionItem];
        return cell;
    }
    else{
        if (((ServicePositionDetialCellItem *)_detialeInfoArray[indexPath.section][indexPath.row]).flag == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
                cell.textLabel.numberOfLines = 0;
                cell.detailTextLabel.numberOfLines = 0;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.font = [UIFont fontWithType:0 size:15];
                cell.detailTextLabel.font = [UIFont fontWithType:0 size:15];
            }
            cell.textLabel.text = ((ServicePositionDetialCellItem *)_detialeInfoArray[indexPath.section][indexPath.row]).titleText;
            cell.detailTextLabel.text = ((ServicePositionDetialCellItem *)_detialeInfoArray[indexPath.section][indexPath.row]).detialText;
            
            return cell;
        }
        else{ //因为电话号码一排不能显示完全，所以使用flag
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.font = [UIFont fontWithType:0 size:15];
            }
            cell.textLabel.text = ((ServicePositionDetialCellItem *)_detialeInfoArray[indexPath.section][indexPath.row]).titleText;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        cloudAppoint.sercersPositionInfo = _servicePositionItem;
        if (_servicePositionItem.type == 1){
            //临时服务点
            cloudAppoint.appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",
                                               [NSDate getYear_Month_DayByDate:_servicePositionItem.startTime/1000],
                                               [NSDate getHour_MinuteByDate:_servicePositionItem.startTime/1000],
                                               [NSDate getHour_MinuteByDate:_servicePositionItem.endTime/1000]];
        }else{
            cloudAppoint.appointmentDateStr = [NSString stringWithFormat:@"工作日(%@~%@)",
                                               [NSDate getHour_MinuteByDate:_servicePositionItem.startTime/1000],
                                               [NSDate getHour_MinuteByDate:_servicePositionItem.endTime/1000]];
        }
        cloudAppoint.isCustomerServerPoint = NO; //如果是基于现有的服务点预约
        [self.navigationController pushViewController:cloudAppoint animated:YES];
    }else{
        //单位
        CloudAppointmentCompanyViewController* companyCloudAppointment = [[CloudAppointmentCompanyViewController alloc] init];
        companyCloudAppointment.sercersPositionInfo = _servicePositionItem;
        if (_servicePositionItem.type == 1){
            //临时服务点
            companyCloudAppointment.appointmentDateStr = [NSString stringWithFormat:@"%@(%@~%@)",
                                                          [NSDate getYear_Month_DayByDate:_servicePositionItem.startTime/1000],
                                                          [NSDate getHour_MinuteByDate:_servicePositionItem.startTime/1000],
                                                          [NSDate getHour_MinuteByDate:_servicePositionItem.endTime/1000]];
        }else{
            companyCloudAppointment.appointmentDateStr = [NSString stringWithFormat:@"工作日(%@~%@)",
                                                          [NSDate getHour_MinuteByDate:_servicePositionItem.startTime/1000],
                                                          [NSDate getHour_MinuteByDate:_servicePositionItem.endTime/1000]];
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
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;

    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_servicePositionItem.positionLa, _servicePositionItem.positionLo);
    [_mapView setCenterCoordinate:coor animated:YES];

    BMKPointAnnotation *anno = [[BMKPointAnnotation alloc]init];
    anno.coordinate = coor;
    anno.title = _servicePositionItem.address;
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
    NSLog(@"location:%f  %f", _locationServer.userLocation.location.coordinate.latitude, _locationServer.userLocation.location.coordinate.longitude);
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
    NSLog(@"location");
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
