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
#import <BaiduMapAPI_Base/BMKTypes.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "UIImage+Rotate.h"
#import "RouteAnnotation.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface TemperaryServicePDeViewController()<UITableViewDelegate, UITableViewDataSource, BMKLocationServiceDelegate, BMKMapViewDelegate, BMKRouteSearchDelegate>
{
    BMKMapView  *_mapView;
    BMKLocationService *_locationServer;
    BMKRouteSearch* _routesearch;
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
                cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
                cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
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
                cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
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

    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
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
    end.pt = CLLocationCoordinate2DMake(_servicePositionItem.positionLa, _servicePositionItem.positionLo);

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
    NSLog(@"temperary dealloc");
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
