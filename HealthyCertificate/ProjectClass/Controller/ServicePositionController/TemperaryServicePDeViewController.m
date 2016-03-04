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

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"

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
    ServicePositionDetialCellItem *memberList = [[ServicePositionDetialCellItem alloc]initWithTitle:@"随行列表" detialText:_servicePositionItem.brOutCheckArrange.memberList];
    NSMutableArray *arry1 = [NSMutableArray arrayWithObjects:personInfo, leader, driver, memberList, nil];

    ServicePositionDetialCellItem *detials = [[ServicePositionDetialCellItem alloc]initWithTitle:@"详情介绍" detialText:@""];
    ServicePositionDetialCellItem *detialsText = [[ServicePositionDetialCellItem alloc]initWithTitle:@"详情介绍" detialText:@""];
    NSMutableArray *arry2 = [NSMutableArray arrayWithObjects:detials, detialsText, nil];

    _detialeInfoArray = [NSMutableArray arrayWithObjects:arry, arry1, arry2, nil];
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
    _orderBtn.layer.borderColor = [UIColor colorWithRed:50/255.0 green:170/255.0 blue:240/255.0 alpha:1].CGColor;
    _orderBtn.layer.borderWidth = 1;
    [_orderBtn setTitle:@"预约" forState:UIControlStateNormal];
    [_orderBtn setTitleColor:[UIColor colorWithRed:50/255.0 green:170/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
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

    UILabel *fenge = [[UILabel alloc]init];
    [self.view addSubview:fenge];
    [fenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    fenge.layer.borderColor = [UIColor lightGrayColor].CGColor;
    fenge.layer.borderWidth = 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_detialeInfoArray.count == 0)
    {
        return 0;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_detialeInfoArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }
    else if(indexPath.section == 1){
        return 44;
    }
    else if (indexPath.section == 2){
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

- (CGFloat)cellheight:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:17];

    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+10;
    return he;
}

- (void)orderBtnClicked:(UIButton *)sender
{
    CloudAppointmentViewController *cloudAppoint = [[CloudAppointmentViewController alloc]init];
    cloudAppoint.sercersPositionInfo = _servicePositionItem;
    cloudAppoint.centerCoordinate = _appointCoordinate;
    cloudAppoint.title = _servicePositionItem.name;

    [self.navigationController pushViewController:cloudAppoint animated:YES];
}

@end
