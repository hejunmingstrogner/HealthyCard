//
//  IndexViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "IndexViewController.h"
#import "Constants.h"
#import "UserInformationController.h"
#import "AppointmentViewController.h"
#import "HttpNetworkManager.h"
#import "ServersPositionAnnotionsModel.h"
#import "PositionUtil.h"
#import "MyCheckListViewController.h"
#import "ServicePointDetailViewController.h"
#import "CloudAppointmentViewController.h"
#import "CloudAppointmentCompanyViewController.h"

@interface IndexViewController ()<UserinfromationControllerDelegate>

{
    CLLocationCoordinate2D _centerCoordinate;
}

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 初始化主界面的view
    [self initSubViews];

    // 定位服务
    [self initLocationServer];

    [self getCheckListData];

    if (GetUserType != 1 && GetUserType != 2 ) {
        [RzAlertView showAlertWithTarget:self.view Title:@"用户类型" oneButtonTitle:@"个人" oneButtonImageName:@"" twoButtonTitle:@"单位" twoButtonImageName:@"" handle:^(NSInteger flag) {
            SetUserType(flag);  // 设置用户类型  1:个人，2单位
            [self initLeftViews];   // 初始化左侧菜单
            [self getCheckListData];
        }];
    }
    else{
        [self initLeftViews];    // 初始化左侧菜单
    }
}

- (void)getCheckListData
{
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        if (!error) {
            NSInteger type = GetUserType;
            if (type == 1) {
                checkListData = [NSMutableArray arrayWithArray:customerArray];
            }
            else if(type == 2)
            {
                checkListData = [NSMutableArray arrayWithArray:brContractArray];
            }
            pendingLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)checkListData.count];
        }
        else {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"获取预约数据失败" removeDelay:2];
            pendingLabel.text = @"";
        }
    }];
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
        make.width.mas_equalTo(90);
    }];
    [pendingBtn setTitle:@"待处理项" forState:UIControlStateNormal];
    pendingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [pendingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [pendingBtn addTarget:self action:@selector(pendingWorkClicked) forControlEvents:UIControlEventTouchUpInside];

    pendingLabel = [[UILabel alloc]init];
    pendingLabel.textColor = [UIColor redColor];
    pendingLabel.textAlignment = NSTextAlignmentRight;
    [headerBackGroundView addSubview:pendingLabel];
    [pendingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(pendingBtn);
        make.width.equalTo(pendingLabel.mas_height);
    }];

    // 最近服务点的位置按钮
    minDistanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBackGroundView addSubview:minDistanceBtn];
    [minDistanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerBackGroundView).offset(-10);
        make.bottom.equalTo(headerBackGroundView);
        make.width.mas_equalTo(70);
        make.height.equalTo(pendingBtn);
    }];
    [minDistanceBtn setImage:[UIImage imageNamed:@"serverPosition"] forState:UIControlStateNormal];
    minDistanceBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 55);
    minDistanceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [minDistanceBtn setTitle:@"0km" forState:UIControlStateNormal];
    minDistanceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
        make.height.mas_equalTo(50);
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
        make.top.equalTo(addressView).offset(5);
        make.bottom.equalTo(addressView).offset(-5);
        make.width.mas_equalTo(1);
    }];

    addressLabel = [[UILabel alloc]init];
    [addressView addSubview:addressLabel];
    addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont systemFontOfSize:15];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fengelabel).offset(10);
        make.right.equalTo(addressView).offset(-10);
        make.top.equalTo(addressView).offset(5);
        make.bottom.equalTo(addressView).offset(-5);
    }];

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

    // 定位到当前位置
    UIButton *removeToCurrentLocateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeToCurrentLocateBtn setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [self.view addSubview:removeToCurrentLocateBtn];
    [removeToCurrentLocateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressView.mas_top).offset(-10);
        make.width.height.mas_equalTo(35);
        make.right.equalTo(self.view).offset(-10);
    }];
    [removeToCurrentLocateBtn addTarget:self action:@selector(removeToCurrentLocate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initLeftViews
{
    // 左侧菜单栏
    leftMenuView = [[LeftMenuView alloc]initWithFrame:CGRectMake(-self.view.frame.size.width * 0.80, 20, self.view.frame.size.width * 0.80 + 10, self.view.frame.size.height - 20)];
    [self.view addSubview:leftMenuView];
    leftMenuView.delegate = self;
    UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerOfMenuView:)];
    panrecognizer.maximumNumberOfTouches = 1;
    [leftMenuView addGestureRecognizer:panrecognizer];
}
#pragma mark - 左侧菜单栏相关
// 菜单界面滑动出现以及关闭
- (void)panGestureRecognizerOfMenuView:(UIPanGestureRecognizer *)recognizer
{
    CGPoint tanslatedPoint = [recognizer translationInView:self.view];
    if (tanslatedPoint.x > 0) {
        moveStatus = YES;       // 右侧移动
    }
    if (tanslatedPoint.x < 0) {
        moveStatus = NO;        // 左侧移动
    }
    if (recognizer.state != UIGestureRecognizerStateEnded && recognizer.state != UIGestureRecognizerStateFailed) {
        CGFloat x = [leftMenuView center].x + tanslatedPoint.x;
        if (x > leftMenuView.frame.size.width/2) {
            x = leftMenuView.frame.size.width/2;
        }
        if (x < -leftMenuView.frame.size.width/2) {
            x = -leftMenuView.frame.size.width/2;
        }
        [leftMenuView setCenter:CGPointMake(x, leftMenuView.center.y)];
        [recognizer setTranslation:CGPointZero inView:self.view];

    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // 右侧移动
        if (moveStatus) {
            if (leftMenuView.center.x > -leftMenuView.frame.size.width/2 + leftMenuView.frame.size.width/5) {
                // 显示界面
                [UIView animateWithDuration:0.7 animations:^{
                    leftMenuView.frame = CGRectMake(0, 20, self.view.frame.size.width * 0.80 + 10, self.view.frame.size.height - 20);
                }];
            }
            else {
                [UIView animateWithDuration:0.7 animations:^{
                    leftMenuView.frame = CGRectMake(-self.view.frame.size.width * 0.80, 20, self.view.frame.size.width * 0.8 + 10, self.view.frame.size.height - 20);
                }];
            }
        }
        else if(moveStatus == NO)
        {
            if (leftMenuView.center.x > leftMenuView.frame.size.width/2 - leftMenuView.frame.size.width/5) {
                // 显示界面
                [UIView animateWithDuration:0.7 animations:^{
                    leftMenuView.frame = CGRectMake(0, 20, self.view.frame.size.width * 0.80 + 10, self.view.frame.size.height - 20);
                }];
            }
            else {
                [UIView animateWithDuration:0.7 animations:^{
                    leftMenuView.frame = CGRectMake(-self.view.frame.size.width * 0.80, 20, self.view.frame.size.width * 0.8 + 10, self.view.frame.size.height - 20);
                }];
            }
        }
    }
}

#pragma mark leftMenuView  delegate
- (void)leftMenuViewOfTableviewDidSelectItemWithType:(LeftMenuCellItemType)type
{
    switch (type) {
        case LEFTMENUCELL_USERINFOR:{
            NSLog(@"用户信息");
            UserInformationController *userinfor = [[UserInformationController alloc]init];
            userinfor.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:userinfor];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case LEFTMENUCELL_HISTORYRECORD:
            NSLog(@"历史记录");
            break;
        case LEFTMENUCELL_SETTING:
            NSLog(@"设置");
            break;
        case LEFTMENUCELL_NOTICE:{
            NSLog(@"体检注意事项");
            PhysicalExaminationViewController *phy = [[PhysicalExaminationViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:phy];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case LEFTMENUCELL_SHARE:
            NSLog(@"分享");
            break;
        case LEFTMENUCELL_ABOUTUS:{
            NSLog(@"关于我们");
            AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:aboutUs];
            [self presentViewController:nav animated: YES completion:nil];
            break;
        }
        case LEFTMENUCELL_ADVICE:{
            NSLog(@"意见或建议");
            AdviceViewController *advice = [[AdviceViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:advice];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case LEFTMENUCELL_EXIT:
            NSLog(@"退出");
            break;
        default:
            break;
    }
}

#pragma  mark - delegtate  改变了个人信息之后，刷新左侧界面
- (void)reloadLeftMenuViewByChangedUserinfor
{
    NSLog(@"刷新");
    [leftMenuView initData];
    [leftMenuView.tableView reloadData];
}
// 左侧用户类型改变之后
- (void)leftMenuViewIsChangedUserType
{
    [self getCheckListData];
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

// 重新定位到当前用户的位置
- (void)removeToCurrentLocate
{
    [_locationServer startUserLocationService];
    [_mapView setCenterCoordinate:_locationServer.userLocation.location.coordinate animated:YES];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
}
#pragma mark -点击待处理项按钮
// 点击待处理按钮
- (void)pendingWorkClicked
{
    if (checkListData.count == 0) {
        return;
    }
    MyCheckListViewController *checkcontroller = [[MyCheckListViewController alloc]init];
    checkcontroller.checkDataArray = [NSMutableArray arrayWithArray:checkListData];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:checkcontroller];
    [self presentViewController:nav animated:YES completion:nil];
}
// 最近的服务
- (void)minDistanceBtnClicked
{
    NSLog(@"最近距离服务");
    if (nearbyServicePositionsArray.count == 0) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"附近没有服务点" removeDelay:2];
        return ;
    }
    if (GetUserType == 1) {     // 个人
        CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
        cloudAppoint.sercersPositionInfo = nearbyServicePositionsArray[0];
        cloudAppoint.centerCoordinate = _mapView.centerCoordinate;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cloudAppoint];
        cloudAppoint.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {                      // 单位
        CloudAppointmentCompanyViewController *cloudAppointCompany = [[CloudAppointmentCompanyViewController alloc]init];
        cloudAppointCompany.sercersPositionInfo = nearbyServicePositionsArray[0];
        cloudAppointCompany.centerCoordinate = _mapView.centerCoordinate;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cloudAppointCompany];
        cloudAppointCompany.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
        [self presentViewController:nav animated:YES completion:nil];
    }

}
//  一键预约
- (void)orderBtnClicked
{
    if (addressLabel.text == nil){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"位置信息未加载完成" removeDelay:3];
    }else{
        [self performSegueWithIdentifier:@"AppointmentIdentifier" sender:self];
    }
}
// 点击了头像,显示左侧菜单
- (void)headerBtnClicked
{
    [UIView animateWithDuration:0.7 animations:^{
        leftMenuView.frame = CGRectMake(0, 20, self.view.frame.size.width * 0.80 + 10, self.view.frame.size.height - 20);
    }];
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
    //_mapView.userTrackingMode = BMKUserTrackingModeNone;
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
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"定位失败,请检查网络后重试" removeDelay:2];
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
    _mapView.zoomLevel = 14;
}

// 拖拽地图设置用户服务位置
- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
    if (changeStatusTimer != nil) {
        [changeStatusTimer invalidate];
    }
    changeStatusTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(getAdress) userInfo:nil repeats:NO];
}

#pragma mark -得到体检地址 获取附近服务点信息
// 得到体检地址
- (void)getAdress
{
    [[LocationSearchModel getInstance] getExaminationAdressByLocation:_mapView.centerCoordinate WithBlock:^(NSString *city,NSString *adress, NSError *error) {
        if(!error)
        {
            currentCityName = city;
            addressLabel.text = adress;
            _centerCoordinate = _mapView.centerCoordinate;
            [[HttpNetworkManager getInstance] getNearbyServicePointsWithCLLocation:_mapView.centerCoordinate resultBlock:^(NSArray *result, NSError *error) {
                // 将附近的服务点显示出来
                if (!error) {
                    [_mapView removeAnnotations:_mapView.annotations];

                    nearbyServicePositionsArray = [NSMutableArray arrayWithArray:result];

                    // 计算最近的服务点距离并将数据排序
                    [self calculateMinDistance];

                    if (nearbyServicePositionsArray.count != 0) {

                        [self addServersPositionAnnotionsWithList:nearbyServicePositionsArray];
                    }
                }
                else {
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"获取附近服务点信息失败" removeDelay:2];
                }
            }];
        }
        else {
            addressLabel.text = @"";
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接出现错误" removeDelay:2];
        }
        [changeStatusTimer invalidate];
    }];
}

#pragma mark -添加地图标注
- (void)addServersPositionAnnotionsWithList:(NSArray *)positions
{
    int i = 0;
    for (ServersPositionAnnotionsModel *service in positions) {
        MyPointeAnnotation *annotion = [[MyPointeAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = service.positionLa;
        coor.longitude = service.positionLo;
        annotion.coordinate = coor;
        annotion.title = service.address;
        annotion.tag = i;
        [_mapView addAnnotation:annotion];
        i++;
    }
}

#pragma mark - annotionview delegate
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    MyPointeAnnotation *anno = view.annotation;
    if (nearbyServicePositionsArray.count != 0) {
        // 回调 0 取消，1预约，2显示基本信息，3拨打电话
        [RzAlertView showActionSheetWithTarget:self.view servicePosition:nearbyServicePositionsArray[anno.tag] handle:^(NSInteger flag) {
            if (flag == 1)
            {
                CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
                cloudAppoint.sercersPositionInfo = nearbyServicePositionsArray[anno.tag];
                cloudAppoint.centerCoordinate = _mapView.centerCoordinate;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cloudAppoint];
                cloudAppoint.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
                [self presentViewController:nav animated:YES completion:nil];
            }
            else if(flag == 2){
                // 移动服务点
                if(((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[anno.tag]).type == 1){
                    TemperaryServicePDeViewController *serviceDetailcon = [[TemperaryServicePDeViewController alloc]init];
                    serviceDetailcon.servicePositionItem = nearbyServicePositionsArray[anno.tag];
                    serviceDetailcon.appointCoordinate = _mapView.centerCoordinate;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:serviceDetailcon];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                else { // 固定服务点
                    ServicePointDetailViewController *servicedetial = [[ServicePointDetailViewController alloc]init];
                    servicedetial.serverPositionItem = nearbyServicePositionsArray[anno.tag];
                    servicedetial.appointCoordinate = _mapView.centerCoordinate;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:servicedetial];
                    [self presentViewController:nav animated:YES completion:nil];
                }
            }
            else if(flag == 3){
                NSLog(@"拨打电话");
            }
        }];
    }
}

#pragma mark - Storyboard Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AppointmentIdentifier"]){
        if ([segue.destinationViewController isKindOfClass:[AppointmentViewController class]]){
            AppointmentViewController* controller = (AppointmentViewController*)segue.destinationViewController;
            controller.location = addressLabel.text;
            controller.nearbyServicePointsArray = nearbyServicePositionsArray;
            
            // 将百度地图左边转换为gps坐标
            PositionUtil *posit = [[PositionUtil alloc]init];
            CLLocationCoordinate2D coor = [posit bd2wgs:_mapView.centerCoordinate.latitude lon:_mapView.centerCoordinate.longitude];
            controller.centerCoordinate = coor;
        }
    }
}

#pragma mark - 计算附近最近的服务点到当前定位点的距离
-(void)calculateMinDistance
{
    if (nearbyServicePositionsArray.count != 0) {
        NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
        for (ServersPositionAnnotionsModel *point in nearbyServicePositionsArray) {
            BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(point.positionLa,point.positionLo));
            BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(_mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude));
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1, point2);
            point.distance = [[NSString stringWithFormat:@"%0.2f", distance/1000] doubleValue];
            [distanceArray addObject:point];
        }
        nearbyServicePositionsArray = [NSMutableArray arrayWithArray:distanceArray];
        // 排序，距离以小到大
        [nearbyServicePositionsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {

            double a = [(ServersPositionAnnotionsModel *)obj1 distance];
            double b = [(ServersPositionAnnotionsModel *)obj2 distance];
            if ( a > b) {
                return NSOrderedDescending;
            }
            else if(a < b){
                return NSOrderedAscending;
            }
            else
                return NSOrderedSame;
        }];
        float mindistance = [((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]) distance];

        // 显示最近距离
        [minDistanceBtn setTitle:[NSString stringWithFormat:@"%0.2fkm", mindistance] forState:UIControlStateNormal];
    }
    else{
        [minDistanceBtn setTitle:@"暂无" forState:UIControlStateNormal];
    }
}
@end
