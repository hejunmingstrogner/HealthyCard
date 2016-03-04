//
//  HistoryInformationVController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/3.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HistoryInformationVController.h"
#import <Masonry.h>
#import "Constants.h"
#import "CustomerHistoryTBVCell.h"
#import "RzAlertView.h"
#import "HttpNetworkManager.h"

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface HistoryInformationVController ()<UITableViewDataSource, UITableViewDelegate>
{
    RzAlertView *waitAlertView;
}


@end

@implementation HistoryInformationVController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];

    [self getData];
}

- (void)getData{

    if (!waitAlertView) {
        waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"数据加载中..."];
    }
    [waitAlertView show];
    [[HttpNetworkManager getInstance]findCustomerTestHistoryRegByCustomId:gPersonInfo.mCustCode resuluBlock:^(NSArray *result, NSError *error) {
        [waitAlertView close];
        if (!error) {
            if (result.count != 0) {
                _historyArray = [[NSMutableArray alloc]initWithArray:result];
                [_tableView reloadData];
            }
            else {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"没有个人记录" removeDelay:3];
            }
        }
        else {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"数据加载出错，请稍候重试" removeDelay:3];
            NSLog(@"error:%@", error);
        }
    }];
}

- (void)initNavgation
{
    self.title = @"历史记录";
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


- (void)initSubViews
{
    _userType = GetUserType;

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    _tableView.dataSource = self;
    _tableView.delegate = self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _historyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 个人
    if (_userType == 1) {
        CustomerHistoryTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CustomerHistoryTBVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell.reportBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.customerTest = (CustomerTest *)_historyArray[indexPath.section];
        cell.reportBtn.tag = indexPath.section;

        return cell;
    }
    // 单位
    else{
//        if (indexPath.row == 0) {
//            BRContractTableHeaerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellheader"];
//            if (!cell) {
//                cell = [[BRContractTableHeaerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellheader"];
//            }
//            [cell setCellItem:(BRContract *)checkDataArray[indexPath.section]];
//            return cell;
//        }
//        else {
//            BRContractTableFootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellfoot"];
//            if (!cell ) {
//                cell = [[BRContractTableFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellfoot"];
//            }
//            [cell setCellItem:(BRContract *)checkDataArray[indexPath.section]];
//            return cell;
//    }
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 个人
    if (_userType == 1) {
//        PersonalHealthyCController *personalHealthyC = [[PersonalHealthyCController alloc]init];
//        personalHealthyC.customerTestInfo = (CustomerTest *)checkDataArray[indexPath.section];
//        [self.navigationController pushViewController:personalHealthyC animated:YES];
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
// 报告按钮点击
- (void)reportBtnClicked:(CustomButton *)sender
{
    NSLog(@"报告：%d", sender.tag);
}

@end