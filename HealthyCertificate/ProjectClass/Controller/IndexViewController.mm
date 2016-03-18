//
//  IndexViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "IndexViewController.h"

#import "Constants.h"
#import "ServersPositionAnnotionsModel.h"

#import "HttpNetworkManager.h"
#import "HMNetworkEngine.h"
#import "PositionUtil.h"

#import "NSDate+Custom.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#import "UserInformationController.h"
#import "AppointmentViewController.h"
#import "MyCheckListViewController.h"
#import "ServicePointDetailViewController.h"
#import "CloudAppointmentViewController.h"
#import "CloudAppointmentCompanyViewController.h"
#import "HistoryInformationVController.h"
#import "LoginController.h"
#import "QRController.h"

#import "OrdersAlertView.h"

NSString *gCurrentCityName;

BOOL   _isLocationInfoHasBeenSent;


@interface IndexViewController ()<UserinfromationControllerDelegate>

{
    CLLocationCoordinate2D _centerCoordinate;
    CustomButton  *coverBtn;            // 遮罩按钮
}

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self initSubViews];

    // 定位服务
    [self initLocationServer];

    NSInteger userTypeflag = GetUserType;

    if (gPersonInfo.cUnitCode == nil || [gPersonInfo.cUnitCode isEqualToString:@""]) {
        if (userTypeflag != 1) {
            SetUserType(1);
            userTypeflag  = 1;
        }
    }
    if (userTypeflag != 1 && userTypeflag != 2 ) {
        [RzAlertView showAlertWithTarget:self.view Title:@"用户类型" oneButtonTitle:@"个人" oneButtonImageName:@"" twoButtonTitle:@"单位" twoButtonImageName:@"" handle:^(NSInteger flag) {
            // 设置用户类型  1:个人，2单位
            if(flag == 1) {
                SetUserType(1);
            }
            else {
                SetUserType(2);
            }
            [self initLeftViews];   // 初始化左侧菜单
            [self getCheckListData];
        }];
    }
    else{
        [self getCheckListData];
        [self initLeftViews];    // 初始化左侧菜单
    }
    
    [self onCheckVersion];
}

//版本更新
-(void)onCheckVersion
{
    [[HttpNetworkManager getInstance] checkVersionWithResultBlock:^(BOOL result, NSError *error) {
        
        if (result == NO){
            //提示用户更新
            [RzAlertView showAlertViewControllerWithTarget:self Title:@"提醒" Message:@"发现新版本，更新将带来更好的用户体检" preferredStyle:UIAlertControllerStyleAlert ActionTitle:@"更新" Actionstyle:UIAlertActionStyleDestructive cancleActionTitle:@"取消" handle:^(NSInteger flag) {
                //回调  flag ＝ 1 执行action，flag ＝ 0 执行取消
                if (flag == 1){
                    //更新
                    NSString *appStoreLink = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",@"1093442955"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
                }
            }];
        }
    }];
}

- (void)getCheckListData
{
    if (GetUserType != 1 && GetUserType != 2) {
        return;
    }
    _isRefreshData = YES;
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
            //[RzAlertView showAlertLabelWithTarget:self.view Message:@"获取预约数据失败" removeDelay:2];
            pendingLabel.text = @"0";
        }
        _isRefreshData = NO;
    }];
}

// 初始化主界面的view
- (void)initSubViews
{
    _mapView = [[BMKMapView alloc]init];
    [self.view addSubview:_mapView];
    self.view.backgroundColor = [UIColor whiteColor];

    // 头部的背景
    UIView *headerBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 74)];
    headerBackGroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerBackGroundView];

    // 头像按钮
    headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBackGroundView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBackGroundView).offset(7);
        make.left.equalTo(headerBackGroundView).offset(10);
        make.width.height.mas_equalTo(30);
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
    titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:20];
    titleLabel.text = @"健康证在线";
    // 待处理按钮
    pendingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBackGroundView addSubview:pendingBtn];
    [pendingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackGroundView).offset(10);
        make.bottom.equalTo(headerBackGroundView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(112);
    }];
    [pendingBtn setTitle:@"待处理项" forState:UIControlStateNormal];
    pendingBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    pendingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [pendingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [pendingBtn addTarget:self action:@selector(pendingWorkClicked) forControlEvents:UIControlEventTouchUpInside];

    pendingLabel = [[UILabel alloc]init];
    pendingLabel.textColor = [UIColor redColor];
    pendingLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    pendingLabel.textAlignment = NSTextAlignmentLeft;
    [headerBackGroundView addSubview:pendingLabel];
    [pendingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(pendingBtn);
        make.width.equalTo(pendingLabel.mas_height).offset(10);
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
    [minDistanceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    [orderBtn setTitle:@"一键预约" forState:UIControlStateNormal];
    orderBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:18];
    [orderBtn setTitleColor:[UIColor colorWithWhite:0.99 alpha:1] forState:UIControlStateNormal];
    [orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
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
    tijianLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
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
    addressLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fengelabel).offset(10);
        make.right.equalTo(addressView).offset(-10);
        make.top.equalTo(addressView).offset(2);
        make.bottom.equalTo(addressView).offset(-2);
    }];

    // 设置地图view的位置大小
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBackGroundView.mas_bottom).offset(-2);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(orderView.mas_top).offset(1);
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

    // 刷新
    CustomButton *refresBtn = [[CustomButton alloc]init];
    [self.view addSubview:refresBtn];
    [refresBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(removeToCurrentLocateBtn.mas_top).offset(-10);
        make.left.right.height.equalTo(removeToCurrentLocateBtn);
    }];
    [refresBtn setImage:[UIImage imageNamed:@"shuaxindata"] forState:UIControlStateNormal];
    [refresBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"刷新数据中..." removeDelay:2];
        [self getCheckListData];    // 刷新待处理项
        [self getAdress];           // 刷新体检地址
    }];

    // 遮罩层
    coverBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame = self.view.frame;
    [self.view addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
    coverBtn.userInteractionEnabled = NO;
    [coverBtn addTarget:self action:@selector(closeLeftView) forControlEvents:UIControlEventTouchUpInside];
    [coverBtn setBackgroundColor:[UIColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:0]];
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
        // 遮罩
        float alphts = (float)CGRectGetMaxX(leftMenuView.frame)/[UIScreen mainScreen].bounds.size.width;
        [coverBtn setBackgroundColor:[UIColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:alphts]];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // 右侧移动
        if (moveStatus) {
            if (leftMenuView.center.x > -leftMenuView.frame.size.width/2 + leftMenuView.frame.size.width/5) {
                // 显示界面
                [self showLeftView];
            }
            else {
                [self closeLeftView];
            }
        }
        else if(moveStatus == NO)
        {
            if (leftMenuView.center.x > leftMenuView.frame.size.width/2 - leftMenuView.frame.size.width/5) {
                // 显示界面
                [self showLeftView];
            }
            else {
                [self closeLeftView];
            }
        }
    }
}

- (void)showLeftView
{
    // 显示界面
    [UIView animateWithDuration:0.7 animations:^{
        leftMenuView.frame = CGRectMake(0, 20, self.view.frame.size.width * 0.80 + 10, self.view.frame.size.height - 20);
        [coverBtn setBackgroundColor:[UIColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:0.8]];
    }];
    coverBtn.userInteractionEnabled = YES;
}
- (void)closeLeftView
{
    [UIView animateWithDuration:0.7 animations:^{
        leftMenuView.frame = CGRectMake(-self.view.frame.size.width * 0.80, 20, self.view.frame.size.width * 0.8 + 10, self.view.frame.size.height - 20);
        [coverBtn setBackgroundColor:[UIColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:0]];
    }];
    coverBtn.userInteractionEnabled = NO;
}

#pragma mark leftMenuView  delegate
- (void)leftMenuViewOfTableviewDidSelectItemWithType:(LeftMenuCellItemType)type
{
    switch (type) {
        case LEFTMENUCELL_USERINFOR:{
//            NSLog(@"用户信息");
            UserInformationController *userinfor = [[UserInformationController alloc]init];
            userinfor.delegate = self;
            [self.navigationController pushViewController:userinfor animated:YES];
            break;
        }
        case LEFTMENUCELL_HISTORYRECORD:{
//            NSLog(@"历史记录");
            HistoryInformationVController *history = [[HistoryInformationVController alloc]init];
            [self.navigationController pushViewController:history animated:YES];
            break;
        }
        case LEFTMENUCELL_ERWEIMA:{
//            NSLog(@"二维码");
            QRController* qrController = [[QRController alloc] init];
            if (GetUserType == 1){
                //个人
                qrController.qrContent = [NSString stringWithFormat:@"http://webserver.zeekstar.com/webserver/weixin/reservation_main.jsp?_recommenderType=customer&_recommender=%@",gPersonInfo.mCustCode];
                qrController.infoStr = @"您有朋友没办理健康证？二维码分享给他可以快速预约办理。";
                
            }else{
                //单位
                qrController.qrContent = [NSString stringWithFormat:@"http://webserver.zeekstar.com/webserver/weixin/reservation_main.jsp?_recommenderType=serviceUnit&_recommender=%@", gCompanyInfo.cUnitCode];
                qrController.infoStr = @" 让员工扫二维码注册到您的单位，也可以直接分享给他。";
            }
            [self.navigationController pushViewController:qrController animated:YES];
            break;
        }
        case LEFTMENUCELL_SETTING:
//            NSLog(@"设置");
            break;
        case LEFTMENUCELL_NOTICE:{
//            NSLog(@"体检注意事项");
            PhysicalExaminationViewController *phy = [[PhysicalExaminationViewController alloc]init];
            [self.navigationController pushViewController:phy animated:YES];
            break;
        }
        case LEFTMENUCELL_SHARE:
//            NSLog(@"分享");
            break;
        case LEFTMENUCELL_ABOUTUS:{
//            NSLog(@"关于我们");
            AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutUs animated:YES];
            break;
        }
        case LEFTMENUCELL_ADVICE:{
//            NSLog(@"意见或建议");
            AdviceViewController *advice = [[AdviceViewController alloc]init];
            [self.navigationController pushViewController:advice animated:YES];
            break;
        }
        case LEFTMENUCELL_EXIT:
        {
            [RzAlertView showAlertViewControllerWithController:self title:@"提示" message:@"您确定要退出当前账号吗？" confirmTitle:@"确定" cancleTitle:@"点错了" handle:^(NSInteger flag) {
                if (flag == 1) {
                    SetUuid(@"");
                    SetPhoneNumber(@"");
                    RemoveUserType;
                    LoginController* loginViewController = [[LoginController alloc] init];
                    [self presentViewController:loginViewController animated:NO completion:nil] ;
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma  mark - delegtate  改变了个人信息之后，刷新左侧界面
- (void)reloadLeftMenuViewByChangedUserinfor
{
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
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locationServer.delegate = self;
    static int flag = 0;
    if (flag != 0) {
        [self getCheckListData];
    }
    flag++;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

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
    if ([self isRefreshData]) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"刷新中，请稍后..." removeDelay:2];
        return ;
    }
    if (checkListData.count == 0) {
        return;
    }
    MyCheckListViewController *checkcontroller = [MyCheckListViewController new];
    checkcontroller.checkDataArray = [NSMutableArray arrayWithArray:checkListData];
    [self.navigationController pushViewController:checkcontroller animated:YES];
}
#pragma mark -最近服务点 点击
- (void)minDistanceBtnClicked
{
    if (nearbyServicePositionsArray.count == 0) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"附近没有服务点" removeDelay:2];
        return ;
    }
    if (GetUserType == 1) {     // 个人
        CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
        cloudAppoint.cityName = currentCityName;
        cloudAppoint.sercersPositionInfo = nearbyServicePositionsArray[0];
        cloudAppoint.centerCoordinate = _mapView.centerCoordinate;
        cloudAppoint.isCustomerServerPoint = NO; //固定服务点预约
        cloudAppoint.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
        [self.navigationController pushViewController:cloudAppoint animated:YES];
    }
    else {                      // 单位
        CloudAppointmentCompanyViewController *cloudAppointCompany = [[CloudAppointmentCompanyViewController alloc]init];
        cloudAppointCompany.sercersPositionInfo = nearbyServicePositionsArray[0];
        cloudAppointCompany.centerCoordinate = _mapView.centerCoordinate;
        cloudAppointCompany.cityName = currentCityName;
        cloudAppointCompany.isCustomerServerPoint = NO;
        cloudAppointCompany.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
        [self.navigationController pushViewController:cloudAppointCompany animated:YES];
    }
}
#pragma mark - 一键预约
- (void)orderBtnClicked
{
    AppointmentViewController* controller = [[AppointmentViewController alloc] init];
    controller.location = addressLabel.text;
    controller.nearbyServicePointsArray = nearbyServicePositionsArray;
    controller.cityName = currentCityName;

    controller.centerCoordinate = _mapView.centerCoordinate;
    [self.navigationController pushViewController:controller animated:YES];
}
// 点击了头像,显示左侧菜单
- (void)headerBtnClicked
{
    [self showLeftView];
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
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"请检查网络并打开GPS定位后重试" removeDelay:2];
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
    _mapView.showMapScaleBar = YES;
    _mapView.zoomLevel = 14;
    [_mapView setMapScaleBarPosition:CGPointMake(10, 10)];
    _mapView.compassPosition = CGPointMake([UIScreen mainScreen].bounds.size.width - 50, 10);
}

// 拖拽地图设置用户服务位置
- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
    if (changeStatusTimer != nil) {
        [changeStatusTimer invalidate];
    }
    changeStatusTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getAdress) userInfo:nil repeats:NO];
}

#pragma mark -得到体检地址 获取附近服务点信息
// 得到体检地址
- (void)getAdress
{
    [[LocationSearchModel getInstance] getExaminationAdressByLocation:_mapView.centerCoordinate WithBlock:^(NSString *city,NSString *adress, NSError *error) {
        if(!error)
        {
            if (_isLocationInfoHasBeenSent == NO){
                
                // 将百度地图左边转换为gps坐标
                PositionUtil *posit = [[PositionUtil alloc]init];
                CLLocationCoordinate2D coor = [posit bd2wgs:_mapView.centerCoordinate.latitude lon:_mapView.centerCoordinate.longitude];
                //得到定位信息后，需要往排队服务器发送地理位置信息
                [[HMNetworkEngine getInstance] sendCustomerCode:gPersonInfo.mCustCode
                                                      LinkPhone:gPersonInfo.StrTel
                                                             LO:[NSString stringWithFormat:@"%lf", coor.longitude]
                                                             LA:[NSString stringWithFormat:@"%lf", coor.latitude]
                                              PositionDirection:[NSString stringWithFormat:@"%lf", _locationServer.userLocation.heading.magneticHeading]
                                                   PositionAddr:adress
                                                        LocTime:[NSDate date]
                                                       CityName:city];
                _isLocationInfoHasBeenSent = YES;
            }
            currentCityName = city;
            gCurrentCityName = city;
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
                    //[RzAlertView showAlertLabelWithTarget:self.view Message:@"获取附近服务点信息失败" removeDelay:2];
                }
            }];
        }
        else {
            addressLabel.text = @"";
            //[RzAlertView showAlertLabelWithTarget:self.view Message:@"网络连接出现错误" removeDelay:2];
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

#pragma mark - annotionview delegate  点击标注，选择预约点
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    MyPointeAnnotation *anno = view.annotation;
    if (nearbyServicePositionsArray.count != 0) {
        // 回调 0 取消，1预约，2显示基本信息，3拨打电话
        [RzAlertView showActionSheetWithTarget:self.view servicePosition:nearbyServicePositionsArray[anno.tag] handle:^(NSInteger flag) {
            if (flag == 1)
            {
                if (GetUserType == 1) {
                    CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
                    cloudAppoint.sercersPositionInfo = nearbyServicePositionsArray[anno.tag];
                    cloudAppoint.centerCoordinate = _mapView.centerCoordinate;
                    cloudAppoint.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
                    [self.navigationController pushViewController:cloudAppoint animated:YES];
                }
                else if (GetUserType == 2)
                {
                    CloudAppointmentCompanyViewController *cloudAppointCompany = [[CloudAppointmentCompanyViewController alloc]init];
                    cloudAppointCompany.sercersPositionInfo = nearbyServicePositionsArray[anno.tag];
                    cloudAppointCompany.centerCoordinate = _mapView.centerCoordinate;
                    cloudAppointCompany.cityName = currentCityName;
                    cloudAppointCompany.isCustomerServerPoint = NO;
                    cloudAppointCompany.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[anno.tag]).name;
                    [self.navigationController pushViewController:cloudAppointCompany animated:YES];
                }
            }
            else if(flag == 2){
                // 移动服务点
                if(((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[anno.tag]).type == 1){
                    TemperaryServicePDeViewController *serviceDetailcon = [[TemperaryServicePDeViewController alloc]init];
                    serviceDetailcon.servicePositionItem = nearbyServicePositionsArray[anno.tag];
                    serviceDetailcon.appointCoordinate = _mapView.centerCoordinate;
                    [self.navigationController pushViewController:serviceDetailcon animated:YES];
                }
                else { // 固定服务点
                    ServicePointDetailViewController *servicedetial = [[ServicePointDetailViewController alloc]init];
                    servicedetial.serverPositionItem = nearbyServicePositionsArray[anno.tag];
                    servicedetial.appointCoordinate = _mapView.centerCoordinate;
                    [self.navigationController pushViewController:servicedetial animated:YES];
                }
            }
            else if(flag == 3){
                NSLog(@"拨打电话");
            }
        }];
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
