//
//  PersonalCheckListViewContrller.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PersonalCheckListViewContrller.h"
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

@interface PersonalCheckListViewContrller()<DJRefreshDelegate, PayMoneyDelegate>
{
    DJRefresh  *_refresh;
    RzAlertView *waitAlertView;
    NSInteger  payIndexPathSection;
}

@property (nonatomic, assign, getter=isRefreshing) BOOL isRefreshing;

@end

@implementation PersonalCheckListViewContrller

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

    // 批量支付
    UIButton *piliangPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [piliangPayBtn setTitle:@"批量支付" forState:UIControlStateNormal];
    [piliangPayBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    piliangPayBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    piliangPayBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    piliangPayBtn.tag = 0;   // tag ＝ 0非编辑状态  ＝1 为编辑状态
    piliangPayBtn.frame = CGRectMake(0, 0, 60, 30);
    [piliangPayBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnitem = [[UIBarButtonItem alloc]initWithCustomView:piliangPayBtn];

    self.navigationItem.rightBarButtonItem = rightBtnitem;
}

- (void)rightBtnClicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        sender.tag = 1;
    }
    else {
        [sender setTitle:@"批量支付" forState:UIControlStateNormal];
        sender.tag = 0;
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
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
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    _tableView.dataSource = self;
    _tableView.delegate = self;

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
            weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];

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

            weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];

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
    return 165;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 个人
    CustomerTest *customertest = (CustomerTest *)_checkDataArray[indexPath.section];
    CustomerTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CustomerTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.payMoneyBtn addTarget:self action:@selector(payMoneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cancelAppointBtn addTarget:self action:@selector(cancelAppointBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell setCellItemWithTest:customertest];
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerTest *customertest = (CustomerTest *)_checkDataArray[indexPath.section];
    if (customertest.payMoney <= 0 && [customertest.testStatus isEqualToString:@"-1"]) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    __weak typeof(self) weakSelf = self;
//    // 个人
//
//    PersonalHealthyCController *personalHealthyC = [[PersonalHealthyCController alloc]init];
//    personalHealthyC.customerTestInfo = (CustomerTest *)_checkDataArray[indexPath.section];
//    [personalHealthyC changedInformationWithResultBlock:^(BOOL ischanged, NSInteger indexpathSection) {
//        if (ischanged) {
//            [weakSelf refreshNewDataWithIndexPathSection:indexPath.section];
//        }
//    }];
//    [self.navigationController pushViewController:personalHealthyC animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark -取消预约，在线支付，付款
- (void)cancelAppointBtnClicked:(UIButton *)sender
{
    __weak typeof(self) _self = self;
    [RzAlertView showAlertViewControllerWithController:self title:@"提示" message:[NSString stringWithFormat:@"您确定要取消 %@ 的体检预约吗？", ((CustomerTest *)_checkDataArray[sender.tag]).custName] confirmTitle:@"确定" cancleTitle:@"点错了" handle:^(NSInteger flag) {
        if (flag != 0) {
            [_self cancelChecked:sender.tag];
        }
    }];
}
// 取消个人预约预约
- (void)cancelChecked:(NSInteger )index
{
    __weak typeof(self) _self = self;
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
@end

