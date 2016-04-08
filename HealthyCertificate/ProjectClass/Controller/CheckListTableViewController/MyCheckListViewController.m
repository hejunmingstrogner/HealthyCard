//
//  MyCheckListViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "MyCheckListViewController.h"
#import "Constants.h"

#import "HttpNetworkManager.h"
#import "DJRefresh.h"

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "NSDate+Custom.h"

#import "BaseTBCellItem.h"
#import "BRContract.h"

#import "CompanyAppointmentListViewController.h"
#import "CloudAppointmentCompanyViewController.h"
#import "PersonalHealthyCController.h"

#import "CustomerTestTableViewCell.h"
#import "BRContractTableHeaerCell.h"
#import "BRContractTableFootCell.h"


#import "CheckListPayMoneyCell.h"
#import "PayMoneyController.h"
#import "UnitCheckListTableviewCell.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface MyCheckListViewController()<DJRefreshDelegate, PayMoneyDelegate>
{
    DJRefresh  *_refresh;
    RzAlertView *waitAlertView;
    NSInteger  payIndexPathSection;
}

@property (nonatomic, assign, getter=isRefreshing) BOOL isRefreshing;

@end

@implementation MyCheckListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];
}

- (void)initNavgation
{
    self.title = @"我的体检";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
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
    _tableView.separatorStyle = NO;

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];

    _refresh = [[DJRefresh alloc]initWithScrollView:_tableView delegate:self];
    _refresh.topEnabled = YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}
// 刷新
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction
{
    _isRefreshing = YES;
    __weak typeof(self) weakself = self;
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        weakself.isRefreshing = NO;
        if (!error) {
            if (_userType == 1) {
                weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];
            }
            else if (_userType == 2) {
                weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];
            }
            [weakself.tableView reloadData];
        }
        else {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"刷新失败，请检查网络后重试" removeDelay:2];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [refresh finishRefreshingDirection:direction animation:YES];
        });
    }];
}
// 刷新某一行
- (void)refreshNewDataWithIndexPathSection:(NSInteger )indexpathSection{
    if (!waitAlertView) {
        waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"刷新中..."];
    }
    [waitAlertView show];
    __weak typeof(self) weakself = self;
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        [waitAlertView close];
        if (!error) {
            if (_userType == 1) {
                weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];
            }
            else if (_userType == 2) {
                weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];
            }
            NSIndexSet *indexset = [[NSIndexSet alloc]initWithIndex:indexpathSection];
            [weakself.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationLeft];
        }
        else {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"刷新失败，请检查网络后重试" removeDelay:2];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _checkDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_userType == 1) {
        return 2;
    }
    else if (_userType == 2){
        return 1;
    }
    return 0;
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
        if (indexPath.row == 0) {
            return 130;
        }
        return 35;
    }
    else {
        if ([((BRContract *)_checkDataArray[indexPath.section]).testStatus isEqualToString:@"-1"]) {
            return 35*5;
        }
        return 35*4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 个人
    if (_userType == 1) {
        CustomerTest *customertest = (CustomerTest *)_checkDataArray[indexPath.section];
        if (indexPath.row == 0) {
            CustomerTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[CustomerTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setCellItemWithTest:customertest];
            return cell;
        }
        else {
            CheckListPayMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paycell"];
            if (!cell) {
                cell = [[CheckListPayMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paycell"];
                [cell.payMoneyBtn addTarget:self action:@selector(payMoneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.cancelAppointBtn addTarget:self action:@selector(cancelAppointBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.payMoneyBtn.tag = indexPath.section;
            cell.cancelAppointBtn.tag = indexPath.section;
            cell.payMoney = customertest.payMoney;
            if (![customertest.testStatus isEqualToString:@"-1"] && customertest.payMoney <= 0){
                //单位已经统一付钱
                cell.payMoneyBtn.hidden = YES;
            }
            
            // 是否可以取消订单
            if (![customertest canCancelTheOrder]) {
                cell.cancelAppointBtn.hidden = YES; // 不可取消
            }
            else{
                cell.cancelAppointBtn.hidden = NO;  // 可以取消
            }
            return cell;
        }
    }
    // 单位
    else{
        UnitCheckListTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unitCell"];
        if (!cell) {
            cell = [[UnitCheckListTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unitCell"];
            [cell.cancelOrderBtn addTarget:self action:@selector(cancleUnitOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.brContract = _checkDataArray[indexPath.section];
        cell.cancelOrderBtn.tag = indexPath.section;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    // 个人
    if (_userType == 1) {
        PersonalHealthyCController *personalHealthyC = [[PersonalHealthyCController alloc]init];
        personalHealthyC.customerTestInfo = (CustomerTest *)_checkDataArray[indexPath.section];
        [personalHealthyC changedInformationWithResultBlock:^(BOOL ischanged, NSInteger indexpathSection) {
            if (ischanged) {
                [weakSelf refreshNewDataWithIndexPathSection:indexPath.section];
            }
        }];
        [self.navigationController pushViewController:personalHealthyC animated:YES];
    }
    else if (_userType == 2){ // 单位预约点击
        CloudAppointmentCompanyViewController* companyViewController = [[CloudAppointmentCompanyViewController alloc] init];
        companyViewController.brContract = _checkDataArray[indexPath.section];
        [companyViewController changedInformationWithResultBlock:^(BOOL ischanged, NSIndexPath *indexpath) {
            if (ischanged) {
                [weakSelf refreshNewDataWithIndexPathSection:indexPath.section];
            }
        }];
        [self.navigationController pushViewController:companyViewController animated:YES];
    }
}
#pragma mark -取消预约，在线支付，付款
- (void)cancelAppointBtnClicked:(UIButton *)sender
{
    __weak MyCheckListViewController *_self = self;
    [RzAlertView showAlertViewControllerWithController:self title:@"提示" message:[NSString stringWithFormat:@"您确定要取消 %@ 的体检预约吗？", ((CustomerTest *)_checkDataArray[sender.tag]).custName] confirmTitle:@"确定" cancleTitle:@"点错了" handle:^(NSInteger flag) {
        if (flag != 0) {
            [_self cancelChecked:sender.tag];
        }
    }];
}
// 取消个人预约预约
- (void)cancelChecked:(NSInteger )index
{
    __weak MyCheckListViewController *_self = self;
    [[HttpNetworkManager getInstance]cancleCheckedCustomerTestWithCheckCode:((CustomerTest *)_checkDataArray[index]).checkCode resultBlock:^(BOOL result, NSError *error) {
        if (!error) {
            [RzAlertView showAlertLabelWithTarget:_self.view Message:@"取消预约成功" removeDelay:2];
            [_self.checkDataArray removeObjectAtIndex:index];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:index];
            [_self.tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationLeft];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self.tableView reloadData];
            });
        }
    }];
}
// 点击支付按钮
- (void)payMoneyBtnClicked:(UIButton *)sender
{
    if (sender.tag < 0) {
        return;
    }
    PayMoneyController *pay = [[PayMoneyController alloc]init];
    pay.chargetype = CUSTOMERTEST;
    pay.checkCode = ((CustomerTest *)_checkDataArray[sender.tag]).checkCode;
    pay.cityName = ((CustomerTest *)_checkDataArray[sender.tag]).cityName;
    pay.delegate = self;
    payIndexPathSection = sender.tag;
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma mark -paymoney Delegate 支付款项之后的delegate
/**
 *  支付成功
 */
- (void)payMoneySuccessed{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您的预约支付已完成" removeDelay:2];

    [self refreshNewDataWithIndexPathSection:payIndexPathSection];
}
/**
 *  支付取消
 */
- (void)payMoneyCencel{

    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您取消了支付" removeDelay:2];
    
    [self refreshNewDataWithIndexPathSection:payIndexPathSection];
}
/**
 *  支付失败
 */
- (void)payMoneyFail{
    NSLog(@"预约支付失败");
}

- (void)payMoneyByOthers
{

}

#pragma mark -取消单位预约
- (void)cancleUnitOrderBtnClicked:(UIButton *)sender
{
    [RzAlertView showAlertViewControllerWithController:self title:@"提示" message:[NSString stringWithFormat:@"您确定要取消 %@ 的体检预约吗？", ((BRContract *)_checkDataArray[sender.tag]).unitName] confirmTitle:@"确定" cancleTitle:@"点错了" handle:^(NSInteger flag) {
        if (flag != 0) {
            [self cancleUnitOrder:sender.tag];
        }
    }];
}
- (void)cancleUnitOrder:(NSInteger)index
{
    NSLog(@"取消 %li", (long)index);
}
@end
