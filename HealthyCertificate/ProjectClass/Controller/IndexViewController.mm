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
#import "UIButton+TCHelper.h"
#import "UILabel+FontColor.h"

#import "UserInformationController.h"
#import "AppointmentViewController.h"

#import "PersonalCheckListViewContrller.h"
#import "UnitCheckListVIewController.h"

#import "ServicePointDetailViewController.h"
#import "CloudAppointmentViewController.h"
#import "CloudAppointmentCompanyViewController.h"
#import "LoginController.h"
#import "QRController.h"
#import "WorkerManagerVC.h"
#import "OrdersAlertView.h"
#import "RegisterViewController.h"
#import "PersonalHistoryController.h"
#import "PersonalAppointmentVC.h"
#import "UnitHistoryController.h"

//#import "CompanySearchViewController.h"

NSString *gCurrentCityName;
//BOOL   gIsCheckedUpdate; //判断是否已经更新

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
    [self initSubViews];

    // 定位服务
    [self initLocationServer];

    NSInteger userTypeflag = GetUserType;

    if (gUnitInfo.unitCode == nil || [gUnitInfo.unitCode isEqualToString:@""]) {
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

//    CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeSystem];
//    [self.view addSubview:btn];
//    btn.frame = self.view.frame;
//    [btn addClickedBlock:^(UIButton * _Nonnull sender) {
//        CompanySearchViewController *search = [[CompanySearchViewController alloc]init];
//        [self.navigationController pushViewController:search animated:YES];
//    }];
}

//版本更新
//-(void)onCheckVersion
//{
//    [[HttpNetworkManager getInstance] checkVersionWithResultBlock:^(BOOL result, NSError *error) {
//        
//        if (result == YES){
//            //提示用户更新
//            [RzAlertView showAlertViewControllerWithTarget:self Title:@"提醒" Message:@"发现新版本，更新将带来更好的用户体检" preferredStyle:UIAlertControllerStyleAlert ActionTitle:@"更新" Actionstyle:UIAlertActionStyleDestructive cancleActionTitle:@"取消" handle:^(NSInteger flag) {
//                //回调  flag ＝ 1 执行action，flag ＝ 0 执行取消
//                if (flag == 1){
//                    //更新 444934666 1093442955
//                    NSString *appStoreLink = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",@"1093442955"];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
//                }
//            }];
//        }
//    }];
//}

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
            [pendingLabel setText1:@"未完成" text1Color:[UIColor blackColor] text2:[NSString stringWithFormat:@" %lu ",(unsigned long)checkListData.count] text2Color:[UIColor redColor] text3:@"单" text3Color:[UIColor blackColor] size:15];
        }
        else {
            [checkListData removeAllObjects];
            [pendingLabel setText1:@"未完成" text1Color:[UIColor blackColor] text2:@" 0 " text2Color:[UIColor redColor] text3:@"单" text3Color:[UIColor blackColor] size:15];
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
        make.width.mas_equalTo(100);
    }];
//    [pendingBtn setTitle:@"待处理项" forState:UIControlStateNormal];
    pendingBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    pendingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [pendingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [pendingBtn addTarget:self action:@selector(pendingWorkClicked) forControlEvents:UIControlEventTouchUpInside];

    pendingLabel = [[UILabel alloc]init];
    pendingLabel.textAlignment = NSTextAlignmentLeft;
    [headerBackGroundView addSubview:pendingLabel];
    [pendingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(pendingBtn);
//        make.width.equalTo(pendingLabel.mas_height).offset(10);
        make.edges.equalTo(pendingBtn);
    }];

    // 最近服务点的位置按钮
    minDistanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBackGroundView addSubview:minDistanceBtn];
    [minDistanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerBackGroundView).offset(-10);
        make.bottom.equalTo(headerBackGroundView);
        make.width.mas_equalTo(50);
        make.height.equalTo(pendingBtn);
    }];
    [minDistanceBtn addTarget:self action:@selector(minDistanceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    // 按钮服务点的图片
    UIImageView *serverImage = [[UIImageView alloc]init];
    [minDistanceBtn addSubview:serverImage];
    [serverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(minDistanceBtn);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(22.67);
    }];
    serverImage.image = [UIImage imageNamed:@"serverPosition"];
    minDistanceLabel = [[UILabel alloc]init];
    minDistanceLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [minDistanceBtn addSubview:minDistanceLabel];
    [minDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(minDistanceBtn);
        make.left.equalTo(serverImage.mas_right);
    }];

    //   一键预约背景
    UIView *orderView = [UIView new];
    [self.view addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(68*2/2.6);
    }];
    orderView.backgroundColor = [UIColor whiteColor];
    // 预约按钮
    orderBtn = [[HCBackgroundColorButton alloc] init];
    [orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
    [orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
    [orderBtn setTitle:@"一键预约" forState:UIControlStateNormal];
    orderBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:18];
    [orderView addSubview:orderBtn];
    [orderBtn addTarget:self action:@selector(orderBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(orderView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    orderBtn.layer.masksToBounds = YES;
    orderBtn.layer.cornerRadius = 5;
    // 显示地址的view
    UIView *addressView = [UIView new];
    [self.view addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(headerBackGroundView.mas_bottom).offset(10);

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
//        make.bottom.equalTo(addressView.mas_top).offset(-10);
        make.bottom.equalTo(_mapView).offset(-20);
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
    [refresBtn addTarget:self action:@selector(reloadDatachack) forControlEvents:UIControlEventTouchUpInside];

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

// 刷新数据
- (void)reloadDatachack
{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"刷新数据中..." removeDelay:2];
    [self getCheckListData];    // 刷新待处理项
    [self getAdress];           // 刷新体检地址
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
        else
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
//        case LEFTMENUCELL_HISTORYRECORD:{
////            NSLog(@"历史记录");
//        }
//        case LEFTMENUCELL_ERWEIMA:
//            break;
//        case LEFTMENUCELL_SETTING:
////            NSLog(@"设置");
//            break;
        case LEFTMENUCELL_NOTICE:{
//            NSLog(@"体检注意事项");
            PhysicalExaminationViewController *phy = [[PhysicalExaminationViewController alloc]init];
            [self.navigationController pushViewController:phy animated:YES];
            break;
        }
//        case LEFTMENUCELL_SHARE:
////            NSLog(@"分享");
//            break;
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
                    SetToken(@"");
                    SetUserRole(@"");
                    SetUserName(@"");
                    RemoveUserType;
                    LoginController* loginViewController = [[LoginController alloc] init];
                    [self presentViewController:loginViewController animated:NO completion:nil] ;
                }
            }];
            break;
        }
        // 我的预约
        case LEFTMENUCELL_UNIT_APPOINT:{
            UnitHistoryController *unit = [[UnitHistoryController alloc]init];
            [self.navigationController pushViewController:unit animated:YES];
            break;
        }
        case LEFTMENUCELL_PERSON_APPOINT:
        {
            PersonalHistoryController *historry = [[PersonalHistoryController alloc]init];
            [self.navigationController pushViewController:historry animated:YES];
            break;
        }
        case LEFTMENUCELL_PERSON_ERWEIMA: // 我的二维码
        {
            QRController* qrController = [[QRController alloc] init];
            qrController.qrContent = [NSString stringWithFormat:@"http://webserver.zeekstar.com/webserver/weixin/reservation_main.jsp?_recommenderType=customer&_recommender=%@",gCustomer.custCode];
            qrController.shareText = @"健康证在线实现一键预约、上门体检、送证上门的健康证办理一站式服务。";
            qrController.infoStr = @"将您的二维码分项给朋友、同事、员工、辖区从业人员，让他们通过健康证在线实现一键预约、上门体检、送证上门的健康证办理一站式服务。";
            [self.navigationController pushViewController:qrController animated:YES];

            break;
        }
        case LEFTMENUCELL_UNIT_ERWEIMA: // 单位二维码
        {
            QRController* qrController = [[QRController alloc] init];
            qrController.qrContent = [NSString stringWithFormat:@"http://webserver.zeekstar.com/webserver/weixin/reservation_main.jsp?_recommenderType=serviceUnit&_recommender=%@", gUnitInfo.unitCode];
            qrController.shareText = @"健康证在线实现一键预约、上门体检、送证上门的健康证办理一站式服务。";
            qrController.infoStr = @"将您的二维码分项给朋友、同事、员工、辖区从业人员，让他们通过健康证在线实现一键预约、上门体检、送证上门的健康证办理一站式服务。";
            [self.navigationController pushViewController:qrController animated:YES];
            break;
        }
        case LEFTMENUCELL_PERSON_UNITLOGIN: // 单位注册
        {
            RegisterViewController* unitRegisterVC = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:unitRegisterVC animated:YES];
            break;
        }
        case LEFTMENUCELL_UNIT_WORKERMANAGE: // 单位员工管理
        {
            WorkerManagerVC *manage = [[WorkerManagerVC alloc]init];
            [self.navigationController pushViewController:manage animated:YES];
            break;
        }
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
    if (GetUserType == 1) {
        PersonalCheckListViewContrller *checkVC = [[PersonalCheckListViewContrller alloc]init];
        checkVC.checkDataArray = [NSMutableArray arrayWithArray:checkListData];
        [self.navigationController pushViewController:checkVC animated:YES];
    }
    else {
        UnitCheckListVIewController *checkVe = [[UnitCheckListVIewController alloc]init];
        checkVe.checkDataArray = [NSMutableArray arrayWithArray:checkListData];
        [self.navigationController pushViewController:checkVe animated:YES];
    }
}
#pragma mark -最近服务点 点击
- (void)minDistanceBtnClicked
{
    if (nearbyServicePositionsArray.count == 0) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"附近没有服务点" removeDelay:2];
        return ;
    }
//    if (GetUserType == 1) {     // 个人
//        CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
//        cloudAppoint.cityName = currentCityName;
//        cloudAppoint.sercersPositionInfo = nearbyServicePositionsArray[0];
//        cloudAppoint.centerCoordinate = _mapView.centerCoordinate;
//        cloudAppoint.isCustomerServerPoint = NO; //固定服务点预约
//        cloudAppoint.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
//        [self.navigationController pushViewController:cloudAppoint animated:YES];
//    }
//    else {                      // 单位
//        CloudAppointmentCompanyViewController *cloudAppointCompany = [[CloudAppointmentCompanyViewController alloc]init];
//        cloudAppointCompany.sercersPositionInfo = nearbyServicePositionsArray[0];
//        cloudAppointCompany.centerCoordinate = _mapView.centerCoordinate;
//        cloudAppointCompany.cityName = currentCityName;
//        cloudAppointCompany.isCustomerServerPoint = NO;
//        cloudAppointCompany.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
//        [self.navigationController pushViewController:cloudAppointCompany animated:YES];
//    }

    //服务点详情
    ServersPositionAnnotionsModel* servicePositionAnnotionsModel = (ServersPositionAnnotionsModel*)nearbyServicePositionsArray[0];
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
#pragma mark - 一键预约
- (void)orderBtnClicked
{
    PersonalAppointmentVC* personalAppointVc = [[PersonalAppointmentVC alloc] init];
    personalAppointVc.outCheckServicePoint = moveServicePositionsArray;
    personalAppointVc.fixedServicePoint = fixedPoitnServicePositionsArray;
    if (GetUserType == 2){
        personalAppointVc.location = addressLabel.text;
        personalAppointVc.centerCoordinate = _mapView.centerCoordinate;
    }
    [self.navigationController pushViewController:personalAppointVc animated:YES];
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
    [_mapView setMapScaleBarPosition:CGPointMake(10, 80)];
    _mapView.compassPosition = CGPointMake([UIScreen mainScreen].bounds.size.width - 50, 80);
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
    __weak typeof(self) weakself = self;
    [[LocationSearchModel getInstance] getExaminationAdressByLocation:_mapView.centerCoordinate WithBlock:^(NSString *city,NSString *adress, NSError *error) {
        if(!error)
        {
            typeof(self) strongself = weakself;
            strongself->currentCityName = city;
            gCurrentCityName = city;
            strongself->addressLabel.text = adress;
            strongself->_centerCoordinate = strongself->_mapView.centerCoordinate;
            
            [[HttpNetworkManager getInstance] getFixedSizeCheckSites:gCurrentCityName Coordinate2D:strongself->_mapView.centerCoordinate resultBlock:^(NSArray *result, NSError *error) {
                
                if (error || result.count == 0){
                    [weakself calculateMinDistance];
                    return;
                }
                
                [strongself->nearbyServicePositionsArray removeAllObjects];
                
                [strongself->_mapView removeAnnotations:strongself->_mapView.annotations];
                strongself->nearbyServicePositionsArray = [NSMutableArray arrayWithArray:result];
                [weakself calculateMinDistance];
                if (nearbyServicePositionsArray.count != 0) {
                    [weakself addServersPositionAnnotionsWithList:nearbyServicePositionsArray];
                }
            }];
        }
        else {
            typeof(self) strongself = weakself;
            strongself->addressLabel.text = @"";
            strongself->nearbyServicePositionsArray = [NSMutableArray array];
            // 计算最近的服务点距离并将数据排序
            [weakself calculateMinDistance];
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
    if(![view.annotation isKindOfClass:[MyPointeAnnotation class]])
    {
        return ;
    }
    MyPointeAnnotation *anno = view.annotation;
    if (nearbyServicePositionsArray.count != 0) {
        // 回调 0 取消，1预约，2显示基本信息，3拨打电话
        __weak typeof(self) wself = self;
        [RzAlertView showActionSheetWithTarget:self.view servicePosition:nearbyServicePositionsArray[anno.tag] handle:^(NSInteger flag) {
            if (flag == 1)
            {
                if (GetUserType == 1) {
                    CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
                    cloudAppoint.sercersPositionInfo = nearbyServicePositionsArray[anno.tag];
                    cloudAppoint.centerCoordinate = _mapView.centerCoordinate;
                    cloudAppoint.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[0]).name;
                    [wself.navigationController pushViewController:cloudAppoint animated:YES];
                }
                else if (GetUserType == 2)
                {
                    CloudAppointmentCompanyViewController *cloudAppointCompany = [[CloudAppointmentCompanyViewController alloc]init];
                    cloudAppointCompany.sercersPositionInfo = nearbyServicePositionsArray[anno.tag];
                    cloudAppointCompany.centerCoordinate = _mapView.centerCoordinate;
                    cloudAppointCompany.cityName = currentCityName;
                    cloudAppointCompany.isCustomerServerPoint = NO;
                    cloudAppointCompany.title = ((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[anno.tag]).name;
                    [wself.navigationController pushViewController:cloudAppointCompany animated:YES];
                }
            }
            else if(flag == 2){
                // 移动服务点
                if(((ServersPositionAnnotionsModel *)nearbyServicePositionsArray[anno.tag]).type == 1){
                    TemperaryServicePDeViewController *serviceDetailcon = [[TemperaryServicePDeViewController alloc]init];
                    serviceDetailcon.servicePositionItem = nearbyServicePositionsArray[anno.tag];
                    serviceDetailcon.appointCoordinate = _mapView.centerCoordinate;
                    [wself.navigationController pushViewController:serviceDetailcon animated:YES];
                }
                else { // 固定服务点
                    ServicePointDetailViewController *servicedetial = [[ServicePointDetailViewController alloc]init];
                    servicedetial.serverPositionItem = nearbyServicePositionsArray[anno.tag];
                    servicedetial.appointCoordinate = _mapView.centerCoordinate;
                    [wself.navigationController pushViewController:servicedetial animated:YES];
                }
            }
            else if(flag == 3){
                ServersPositionAnnotionsModel* serverPositionInfo = nearbyServicePositionsArray[anno.tag];
                NSString* urlNumberStr = [NSString stringWithFormat:@"tel://%@", serverPositionInfo.leaderPhone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlNumberStr]];
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
        [minDistanceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
        }];
        [minDistanceLabel setText1:@"最近服务点" text1Color:[UIColor blackColor] text2:[NSString stringWithFormat:@"%0.2f", mindistance] text2Color:[UIColor redColor] text3:@"km" text3Color:[UIColor blackColor] size:15];

        // 将1公里以内的数据分类
        [self getServicePositionInformation];
    }
    else{
        minDistanceLabel.text = @"暂无";
        [_mapView removeAnnotations:_mapView.annotations];
        [minDistanceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(55);
        }];
    }
}
#pragma mark -分别得到固定以及移动服务点  1km 之内的服务点信息
- (void)getServicePositionInformation
{
    if (fixedPoitnServicePositionsArray == nil){
        fixedPoitnServicePositionsArray = [[NSMutableArray alloc] init];
    }
    if (moveServicePositionsArray == nil){
        moveServicePositionsArray = [[NSMutableArray alloc] init];
    }
    
    [fixedPoitnServicePositionsArray removeAllObjects];
    [moveServicePositionsArray removeAllObjects];

    // 将固定服务点的可预约与不可预约的服务点分开
    NSMutableArray *canusePositions = [[NSMutableArray alloc]init];  // 可以预约  innertype ！＝ 2
    NSMutableArray *cannotuserPositions = [[NSMutableArray alloc]init]; // 不可预约 ＝ 2（其他机构）

    for (ServersPositionAnnotionsModel *point in nearbyServicePositionsArray) {
        if (point.type == 0){
            if(point.innerType != 2)
            {
                [canusePositions addObject:point];
            }
            else {
                [cannotuserPositions addObject:point];
            }
        }else if(point.type == 1){   // 移动服务点
            if (point.distance <= 1) {
                [moveServicePositionsArray addObject:point];
            }
        }
    }
    // 将可以预约的服务点放前边
    [fixedPoitnServicePositionsArray addObjectsFromArray:canusePositions];
    [fixedPoitnServicePositionsArray addObjectsFromArray:cannotuserPositions];

//    // 将移动服务点放在地图上
//    [self addServersPositionAnnotionsWithList:moveServicePositionsArray];
//    // 将固定服务点放在地图上
//    [self addServersPositionAnnotionsWithList:fixedPoitnServicePositionsArray];
}
@end
