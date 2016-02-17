//
//  IndexViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 初始化主界面的view
    [self initSubViews];

    // 定位服务
    [self initLocationServer];
}
// 初始化主界面的view
- (void)initSubViews
{
    _mapView = [[BMKMapView alloc]init];
    [self.view addSubview:_mapView];

    // 头部的背景
    UIView *headerBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 74)];
    headerBackGroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerBackGroundView];
    [headerBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(74);
    }];
    // 头像按钮
    headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBackGroundView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBackGroundView).offset(10);
        make.left.equalTo(headerBackGroundView).offset(10);
        make.width.height.mas_equalTo(24);
    }];
    [headerBtn setImage:[UIImage imageNamed:@"headerimage"] forState:UIControlStateNormal];
    headerBtn.layer.masksToBounds = YES;
    headerBtn.layer.cornerRadius = 12;
    [headerBtn addTarget:self action:@selector(headerBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    // 标题
    titleLabel = [[UILabel alloc]init];
    [headerBackGroundView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerBackGroundView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.top.equalTo(headerBtn);
    }];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = @"知康";
    // 待处理按钮
    pendingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBackGroundView addSubview:pendingBtn];
    [pendingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackGroundView).offset(10);
        make.bottom.equalTo(headerBackGroundView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    [pendingBtn setTitle:@"待处理项" forState:UIControlStateNormal];
    pendingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [pendingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [pendingBtn addTarget:self action:@selector(pendingWorkClicked) forControlEvents:UIControlEventTouchUpInside];
    // 最近服务点的位置按钮
    minDistanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBackGroundView addSubview:minDistanceBtn];
    [minDistanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerBackGroundView).offset(-10);
        make.bottom.equalTo(headerBackGroundView);
        make.width.mas_equalTo(100);
        make.height.equalTo(pendingBtn);
    }];

    [minDistanceBtn setTitle:@"1.5km" forState:UIControlStateNormal];
    minDistanceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [minDistanceBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:100/255.0 blue:90/255.0 alpha:1] forState:UIControlStateNormal];
    [minDistanceBtn addTarget:self action:@selector(minDistanceBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    //   一键预约背景
    UIView *orderView = [UIView new];
    [self.view addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(68*2/2.6);
    }];
    orderView.backgroundColor = [UIColor whiteColor];
    // 预约按钮
    orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderView addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(orderView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    orderBtn.layer.masksToBounds = YES;
    orderBtn.layer.cornerRadius = 5;
    orderBtn.layer.borderWidth = 2;
    orderBtn.layer.borderColor = [UIColor colorWithRed:70/255.0 green:180/255.0 blue:240/255.0 alpha:1].CGColor;
    [orderBtn setTitle:@"一键预约" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor colorWithRed:70/255.0 green:180/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
    orderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [orderBtn addTarget:self action:@selector(orderBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    // 显示地址的view
    UIView *addressView = [UIView new];
    [self.view addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(orderView.mas_top).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(60);
    }];
    addressView.backgroundColor = [UIColor whiteColor];

    UILabel *tijianLabel = [[UILabel alloc]init];
    [addressView addSubview:tijianLabel];
    tijianLabel.text = @"体检地址";
    tijianLabel.textAlignment = NSTextAlignmentCenter;
    tijianLabel.font = [UIFont systemFontOfSize:14];
    [tijianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressView).offset(10);
        make.centerY.equalTo(addressView);
        make.width.mas_equalTo(60);
    }];

    UILabel *fengelabel = [[UILabel alloc]init];
    [addressView addSubview:fengelabel];
    fengelabel.backgroundColor = [UIColor grayColor];
    fengelabel.alpha = 0.6;
    [fengelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tijianLabel.mas_right).offset(10);
        make.top.bottom.equalTo(addressView);
        make.width.mas_equalTo(1);
    }];

    addressLabel = [[UILabel alloc]init];
    [addressView addSubview:addressLabel];
    addressLabel.numberOfLines = 0;
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fengelabel).offset(10);
        make.right.equalTo(addressView).offset(-10);
        make.top.equalTo(addressView).offset(5);
        make.bottom.equalTo(addressView).offset(-5);
    }];
    //addressLabel.text = @"成都信息工程大学jksafkljsadfklsjdfkljaskldfjaklsdfjklsdfjklasdfjkl";

    // 设置地图view的位置大小
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBackGroundView);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(orderView.mas_top);
    }];

    locateimageview = [[UIImageView alloc]init];
    [self.view addSubview:locateimageview];
    [locateimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mapView.mas_centerY);
        make.centerX.equalTo(_mapView.mas_centerX);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
    [locateimageview setImage:[UIImage imageNamed:@"locateimage"]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locationServer.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locationServer.delegate = nil;
}

#pragma mark -点击待处理项按钮
// 点击待处理按钮
- (void)pendingWorkClicked
{
    NSLog(@"待处理项");
}
// 最近的服务
- (void)minDistanceBtnClicked
{
    NSLog(@"最近距离服务");
}
//  一键预约
- (void)orderBtnClicked
{
    NSLog(@"一键预约点击");
}
// 点击了头像
- (void)headerBtnClicked
{
    NSLog(@"点击了头像");
}
#pragma mark -初始化定位服务
- (void)initLocationServer
{
    if (![CLLocationManager locationServicesEnabled]) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"GPS定位功能没有开启，为更好的体验，您希望前往开启定位吗？" preferredStyle:UIAlertControllerStyleAlert ActionTitle:@"现在去设置" Actionstyle:UIAlertActionStyleDefault cancleActionTitle:@"取消" handle:^(NSInteger flag) {
            if (flag == 1) {
                NSLog(@"现在去设置");
            }
        }];
    }
    _locationmanager = [[CLLocationManager alloc]init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        [_locationmanager requestWhenInUseAuthorization];
    }

    _locationServer = [[BMKLocationService alloc]init];
    _locationServer.delegate = self;
    [_locationServer startUserLocationService];

    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}

#pragma mark -位置更新时的delegate
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"定位失败，请重试" ActionTitle:@"明白了" ActionStyle:UIAlertActionStyleDefault];
    [_locationServer startUserLocationService];
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
// 地图初始化完成之后
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    NSLog(@"地图初始化完成之后，%f", mapView.centerCoordinate.latitude);
}

// 拖拽地图设置用户服务位置
- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
    if (changeStatusTimer != nil) {
        [changeStatusTimer invalidate];
    }
    changeStatusTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getAdress) userInfo:nil repeats:NO];
}

#pragma mark -得到体检地址
// 得到体检地址
- (void)getAdress
{
    [[LocationSearchModel getInstance] getExaminationAdressByLocation:_mapView.centerCoordinate WithBlock:^(NSString *adress, NSError *error) {
        if(!error)
        {
            addressLabel.text = adress;
        }
        else {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接出现错误" removeDelay:3];
        }
    }];
}
@end
