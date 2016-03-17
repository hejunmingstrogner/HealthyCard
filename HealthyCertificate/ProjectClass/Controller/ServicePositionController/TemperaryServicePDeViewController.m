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

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface TemperaryServicePDeViewController()<UITableViewDelegate, UITableViewDataSource>

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

- (void)initNavgation
{
    self.title = _servicePositionItem.brOutCheckArrange.plateNo;  // 车辆牌照
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

    ServicePositionDetialCellItem *personInfo = [[ServicePositionDetialCellItem alloc]initWithTitle:@"人员详情" detialText:@""];
    ServicePositionDetialCellItem *leader = [[ServicePositionDetialCellItem alloc]initWithTitle:@"负责人" detialText:_servicePositionItem.brOutCheckArrange.leaderName];
    ServicePositionDetialCellItem *driver = [[ServicePositionDetialCellItem alloc]initWithTitle:@"司  机" detialText:_servicePositionItem.brOutCheckArrange.driverName];

    NSMutableArray *arry1 = [NSMutableArray arrayWithObjects:personInfo, leader, driver, nil];

     ServicePositionDetialCellItem *memberList = [[ServicePositionDetialCellItem alloc]initWithTitle:@"服务车辆" detialText:nil];
    ServicePositionDetialCellItem *menberListdata = [[ServicePositionDetialCellItem alloc]initWithTitle:_servicePositionItem.brOutCheckArrange.plateNo detialText:_servicePositionItem.brOutCheckArrange.vehicleInfo];

    NSMutableArray *arry2 = [NSMutableArray arrayWithObjects:memberList, menberListdata, nil];

    ServicePositionDetialCellItem *detials = [[ServicePositionDetialCellItem alloc]initWithTitle:@"详情介绍" detialText:@""];
    ServicePositionDetialCellItem *detialsText = [[ServicePositionDetialCellItem alloc]initWithTitle:@"暂无介绍" detialText:@""];
    NSMutableArray *arry3 = [NSMutableArray arrayWithObjects:detials, detialsText, nil];

    _detialeInfoArray = [NSMutableArray arrayWithObjects:arry, arry1, arry2, arry3, nil];
}

- (void)initSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_orderBtn];
    [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    _orderBtn.layer.masksToBounds = YES;
    _orderBtn.layer.cornerRadius = 5;
    [_orderBtn setTitle:@"预约" forState:UIControlStateNormal];
    [_orderBtn setTitleColor:[UIColor colorWithWhite:0.99 alpha:1] forState:UIControlStateNormal];
    [_orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
    [_orderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_orderBtn.mas_top).offset(-10);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.numberOfLines = 0;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont fontWithType:0 size:15];
            cell.detailTextLabel.font = [UIFont fontWithType:0 size:15];
        }
        cell.textLabel.text = ((ServicePositionDetialCellItem *)_detialeInfoArray[indexPath.section][indexPath.row]).titleText;
        cell.detailTextLabel.text = ((ServicePositionDetialCellItem *)_detialeInfoArray[indexPath.section][indexPath.row]).detialText;

        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else{
            cell.textLabel.textColor = [UIColor grayColor];
        }
        return cell;
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

- (void)orderBtnClicked:(UIButton *)sender
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

@end
