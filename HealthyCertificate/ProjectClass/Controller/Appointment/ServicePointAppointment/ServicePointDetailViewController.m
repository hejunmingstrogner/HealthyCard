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

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

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
    self.title = _serverPositionItem.name;  // 车辆牌照
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
    ServicePositionDetialCellItem *item10 = [[ServicePositionDetialCellItem alloc]initWithTitle:@"详情介绍" detialText:@""];
    ServicePositionDetialCellItem *item11 = [[ServicePositionDetialCellItem alloc]initWithTitle:_serverPositionItem.introduce detialText:@""];
    NSArray *arry1 = [NSArray arrayWithObjects:item10, item11, nil];

    ServicePositionDetialCellItem *item20 = [[ServicePositionDetialCellItem alloc]initWithTitle:@"地址路线" detialText:@""];
    ServicePositionDetialCellItem *item21 = [[ServicePositionDetialCellItem alloc]initWithTitle:@"中心地址" detialText:_serverPositionItem.address];
    ServicePositionDetialCellItem *item22 = [[ServicePositionDetialCellItem alloc]initWithTitle:@"咨询电话" detialText:_serverPositionItem.leaderPhone];
    ServicePositionDetialCellItem *item23 = [[ServicePositionDetialCellItem alloc]initWithTitle:@"公交路线" detialText:_serverPositionItem.busWay.length == 0? @"306、304" : _serverPositionItem.busWay];
    NSArray *arry2 = [NSArray arrayWithObjects:item20, item21, item22, item23, nil];

    _inforArray = [[NSMutableArray alloc]initWithObjects:arry0, arry1, arry2, nil];
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
    return 3;
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
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    else if (indexPath.row == 1){
        if (indexPath.section == 1) {
            return fmaxf(44, [self cellheight:_serverPositionItem.introduce]);
        }
        return fmaxf(44, [self cellheight:_serverPositionItem.busWay]);
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont fontWithType:0 size:15];
            cell.detailTextLabel.font = [UIFont fontWithType:0 size:15];
        }
        cell.textLabel.text = ((ServicePositionDetialCellItem *)_inforArray[indexPath.section][indexPath.row]).titleText;
        cell.detailTextLabel.text = ((ServicePositionDetialCellItem *)_inforArray[indexPath.section][indexPath.row]).detialText;
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else{
            cell.textLabel.textColor = [UIColor grayColor];
        }
        return cell;
    }
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
@end
