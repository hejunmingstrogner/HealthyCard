//
//  MyCheckListViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "MyCheckListViewController.h"
#import "Constants.h"
#import "CustomerTestTableViewCell.h"
#import "BRContract.h"
#import "BRContractTableHeaerCell.h"
#import "BRContractTableFootCell.h"
#import "PersonalHealthyCController.h"
#import "CloudAppointmentCompanyViewController.h"
#import "HttpNetworkManager.h"

@interface MyCheckListViewController()
{
    NSMutableArray *checkDataArray;
    RzAlertView *waitAlertView;
    UIRefreshControl *refreashController;
}

@end

@implementation MyCheckListViewController

@synthesize checkDataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];

    [self getCheckData];
}

- (void)getCheckData{
    if (checkDataArray.count != 0) {
        return ;
    }
    if (waitAlertView == nil) {
        waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"数据加载中..."];
    }
    [waitAlertView show];
    [[HttpNetworkManager getInstance] getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        if (error) {
            waitAlertView.titleLabel.text = @"数据加载出错，请刷新试试";
        }
        if (_userType == 1) {
            checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];
        }
        else if (_userType == 2) {
            checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];
        }
        [_tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            waitAlertView.titleLabel.text = @"数据加载中...";
            [waitAlertView close];
        });

    }];
}

- (void)initNavgation
{
    self.title = @"我的预约";
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    if (_popStyle == POPTO_ROOT){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)initSubViews
{
    _userType = GetUserType;

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    _tableView.dataSource = self;
    _tableView.delegate = self;

    refreashController = [[UIRefreshControl alloc]init];
    refreashController.tintColor = [UIColor lightGrayColor];
    refreashController.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新数据"];
    [refreashController addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreashController];
}

- (void)refreshData {
    refreashController.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中。。。"];
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        if (error) {
            refreashController.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载出错,请重试."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [refreashController endRefreshing];
                refreashController.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新数据"];
            });
            return ;
        }
        if (_userType == 1) {
            checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];
        }
        else if (_userType == 2) {
            checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];
        }
        [_tableView reloadData];
        [refreashController endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            refreashController.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新数据"];
        });
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return checkDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_userType == 1) {
        return 1;
    }
    return 2;
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
    if(_userType == 1){
        return 110;
    }
    else {
        if (indexPath.row == 0) {
            return 80;
        }
        else
        {
            return 40;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 个人
    if (_userType == 1) {
        CustomerTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CustomerTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell setCellItemWithTest:(CustomerTest *)checkDataArray[indexPath.section]];
        return cell;
    }
    // 单位
    else{
        if (indexPath.row == 0) {
            BRContractTableHeaerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellheader"];
            if (!cell) {
                cell = [[BRContractTableHeaerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellheader"];
            }
            [cell setCellItem:(BRContract *)checkDataArray[indexPath.section]];
            return cell;
        }
        else {
            BRContractTableFootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellfoot"];
            if (!cell ) {
                cell = [[BRContractTableFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellfoot"];
            }
            [cell setCellItem:(BRContract *)checkDataArray[indexPath.section]];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 个人
    if (_userType == 1) {
        PersonalHealthyCController *personalHealthyC = [[PersonalHealthyCController alloc]init];
        personalHealthyC.customerTestInfo = (CustomerTest *)checkDataArray[indexPath.section];
        [self.navigationController pushViewController:personalHealthyC animated:YES];
    }
    else {
        // 单位预约点击
//        if (_userType == 2) {
//            CloudAppointmentCompanyViewController *cloudAppointCompany = [[CloudAppointmentCompanyViewController alloc]init];
//            cloudAppointCompany.isCustomerServerPoint = NO;
//            cloudAppointCompany.brContract = checkDataArray[indexPath.section];
//            [self.navigationController pushViewController:cloudAppointCompany animated:YES];
//        }
    }
}

@end
