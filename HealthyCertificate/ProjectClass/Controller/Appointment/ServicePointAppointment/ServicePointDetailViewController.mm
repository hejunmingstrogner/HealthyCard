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
#import <BaiduMapAPI_Base/BMKTypes.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "UIImage+Rotate.h"
#import "RouteAnnotation.h"

#import "UILabel+FontColor.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface ServicePointDetailViewController()<BMKLocationServiceDelegate, BMKMapViewDelegate, BMKRouteSearchDelegate>
{
    BMKMapView  *_mapView;
    BMKLocationService *_locationServer;
    BMKRouteSearch* _routesearch;
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

//    _inforArray = [[NSMutableArray alloc]initWithObjects:arry0, arry1, arry2, nil];
    _inforArray = [[NSMutableArray alloc]initWithObjects:arry0, arry2, nil];
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    _orderBtn = [[HCBackgroundColorButton alloc] init];
    if (_serverPositionItem.innerType == 2){
        _orderBtn.enabled = NO;
        _orderBtn.backgroundColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    }else{
        [_orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
        [_orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
    }
    
    [_orderBtn setTitle:@"预约" forState:UIControlStateNormal];
    [self.view addSubview:_orderBtn];
    [_orderBtn addTarget:self action:@selector(orderBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    _orderBtn.layer.masksToBounds = YES;
    _orderBtn.layer.cornerRadius = 5;

    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200 - 60)];
    _mapView.zoomLevel = 14;
    _mapView.compassPosition = CGPointMake([UIScreen mainScreen].bounds.size.width - 50, 10);
    [self.view addSubview:_mapView];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(200 - 64);
    }];
    // 设置显示服务点信息
    [self addServiersPositionAnno];

    // 用户设置地图滑动的按钮
    CustomButton *scrollBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:scrollBtn];
    [scrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.centerX.equalTo(_tableView);
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
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.view.frame.size.height - 64 - 60 - 200);
        }];
        sender.tag = 2;
        [sender setBackgroundImage:[UIImage imageNamed:@"goUp"] forState:UIControlStateNormal];
    }
    else {
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200-64);
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
//    if (section == 0) {
//        return 40;
//    }
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
//    else if (indexPath.section == 1){
//        return fmaxf(44, [self cellheight:_serverPositionItem.introduce]);
//    }
    return 44;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headView"];
//        if (!view) {
//            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headView"];
//            float hight  = [self tableView:tableView heightForHeaderInSection:section];
//            UIView *uiview = [[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, hight - 2)];
//            [view addSubview:uiview];
//            uiview.backgroundColor = [UIColor whiteColor];
//            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, hight)];
//            label1.tag = 1;
//            [view addSubview:label1];
//
//            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 160 , 0, 150, hight)];
//            label2.textAlignment = NSTextAlignmentRight;
//            label2.tag = 2;
//            [view addSubview:label2];
//        }
//        NSString *text1 = @"还可预约 ";
//        NSString *text2 = [NSString stringWithFormat:@"%d", _serverPositionItem.maxNum - _serverPositionItem.oppointmentNum];
//        NSString *text3 = @"人";
//        UILabel *label1 = [view viewWithTag:1];
//        [label1 setText1:text1 text1Color:[UIColor blackColor] text2:text2 text2Color:[UIColor redColor] text3:text3 text3Color:[UIColor blackColor] size:14];
//
//        NSString *detext1 = @"已预约 ";
//        NSString *detext2 = [NSString stringWithFormat:@"%d", _serverPositionItem.oppointmentNum];
//        NSString *detext3 = @"人";
//        UILabel *label2 = [view viewWithTag:2];
//        [label2 setText1:detext1 text1Color:[UIColor blackColor] text2:detext2 text2Color:[UIColor greenColor] text3:detext3 text3Color:[UIColor blackColor] size:14];
//        return view;
//    }
//    return nil;
//}

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
                cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
                cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
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
                cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
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

    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;

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
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    start.pt = _locationServer.userLocation.location.coordinate;

    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    end.pt = CLLocationCoordinate2DMake(_serverPositionItem.positionLa, _serverPositionItem.positionLo);

    BMKWalkingRoutePlanOption *walk = [[BMKWalkingRoutePlanOption alloc]init];
    walk.from = start;
    walk.to = end;
    BOOL flag = [_routesearch walkingSearch:walk];
    if (!flag) {
        NSLog(@"步行规划失败");
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationServer.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routesearch.delegate = nil; // 不用时，置nil
    _locationServer.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    if (_routesearch != nil) {
        _routesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
    if (_locationServer) {
        _locationServer = nil;
    }
}
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注

            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];

            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }

        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }

        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }

            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;

        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }

            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }

    return view;
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}
@end
