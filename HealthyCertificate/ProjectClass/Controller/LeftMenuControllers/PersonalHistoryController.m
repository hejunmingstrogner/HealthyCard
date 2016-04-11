//
//  PersonalHistoryController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PersonalHistoryController.h"
#import <Masonry.h>
#import "Constants.h"
#import "CustomerHistoryTBVCell.h"
#import "RzAlertView.h"
#import "HttpNetworkManager.h"
#import "HMNetworkEngine.h"

#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"

#import "BRContractHistoryTBHeaderCell.h"
#import "BRContractHistoryTBFootCell.h"
#import "PersonalHealthyCHistoryVC.h"
#import "BaseTBCellItem.h"
#import "BRContractTableFootCell.h"
#import "ContractPersonInfoViewController.h"
#import "CustomerTestTableViewCell.h"
#import "HistoryModel.h"
#import "CheckListPayMoneyCell.h"
#import "PayMoneyController.h"
#import "PersonalHealthyCController.h"
#import "DJRefresh.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface PersonalHistoryController ()<UITableViewDataSource, UITableViewDelegate,HMNetworkEngineDelegate, PayMoneyDelegate, DJRefreshDelegate>
{
    RzAlertView *waitAlertView;
    DJRefresh  *_refresh;
    NSMutableArray *_companyDataArray;

    NSInteger  payIndexPathSection;
}


@end

@implementation PersonalHistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];

//    [self getPersonalData:nil];
}
- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc]init];
    }
    return _historyArray;
}
// 获得个人数据
- (void)getPersonalData:(DJRefresh *)refresh
{
    if (!waitAlertView) {
        waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"数据加载中..."];
    }
    [waitAlertView show];
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        _historyArray = [[NSMutableArray alloc]init];
        if (!error) {
            for (CustomerTest *customer in customerArray) {
                HistoryModel *model = [[HistoryModel alloc]initWithCustomer:customer BRContract:nil type:HISTORY_PERSONAL_UNFINISHED rows:2];
                [_historyArray addObject:model];
            }
        }
        else{
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"获取未完成项失败，请检查网络后重试" removeDelay:2];
        }

        [[HttpNetworkManager getInstance]findCustomerTestHistoryRegByCustomId:gCustomer.custCode resuluBlock:^(NSArray *result, NSError *error) {
            if (!error) {
                for (CustomerTest *customer in result) {
                    HistoryModel *model = [[HistoryModel alloc]initWithCustomer:customer BRContract:nil type:HISTORY_PERSONAL_FINISHED rows:1];
                    [_historyArray addObject:model];
                }
            }
            else {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"数据加载出错，请稍候重试" removeDelay:3];
            }
            if (_historyArray.count == 0) {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"没有历史记录" removeDelay:2];
            }
            [waitAlertView close];
            [_tableView reloadData];
            if(refresh)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [refresh finishRefreshingDirection:DJRefreshDirectionTop animation:YES];
                });
            }
        }];
    }];
}
// 刷新
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction
{
    [self getPersonalData:refresh];
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
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = NO;

    _refresh = [[DJRefresh alloc]initWithScrollView:_tableView delegate:self];
    _refresh.topEnabled = YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _historyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return ((HistoryModel *)_historyArray[section]).rows;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _historyArray.count - 1) {
        return 10;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryModel *model = _historyArray[indexPath.section];
    if (model.type == HISTORY_PERSONAL_UNFINISHED) {
        CustomerTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pcell"];
        if (!cell) {
            cell = [[CustomerTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pcell"];
            [cell.payMoneyBtn addTarget:self action:@selector(payMoneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.cancelAppointBtn addTarget:self action:@selector(cancelAppointBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setCellItemWithTest:model.customer];
        cell.payMoneyBtn.tag = indexPath.section;
        cell.cancelAppointBtn.tag = indexPath.section;
        cell.payMoney = model.customer.payMoney;
        if (![model.customer.testStatus isEqualToString:@"-1"] && model.customer.payMoney <= 0){
            //单位已经统一付钱
            cell.payMoneyBtn.hidden = YES;
        }

        // 是否可以取消订单
        if (![model.customer canCancelTheOrder]) {
            cell.cancelAppointBtn.hidden = YES; // 不可取消
        }
        else{
            cell.cancelAppointBtn.hidden = NO;  // 可以取消
        }

        return cell;
    }
    if(model.type == HISTORY_PERSONAL_FINISHED){
        // 已完成
        CustomerHistoryTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customerHistoryTBVCell"];
        if (!cell) {
            cell = [[CustomerHistoryTBVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customerHistoryTBVCell"];
            [cell.reportBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
#warning 报告先不用
            cell.reportBtn.hidden = YES;
        }
        cell.customerTest = model.customer;
        cell.reportBtn.tag = indexPath.section;
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 已完成的
    if (((HistoryModel *)_historyArray[indexPath.section]).type == HISTORY_PERSONAL_FINISHED) {
        PersonalHealthyCHistoryVC *person = [[PersonalHealthyCHistoryVC alloc]init];
        person.customerTestInfo = ((HistoryModel *)_historyArray[indexPath.section]).customer;
        [self.navigationController pushViewController:person animated:YES];
    }
    else {
        // 未完成的
        __weak typeof(self) weakSelf = self;
        PersonalHealthyCController *personalHealthyC = [[PersonalHealthyCController alloc]init];
        personalHealthyC.customerTestInfo = ((HistoryModel *)_historyArray[indexPath.section]).customer;
        [personalHealthyC changedInformationWithResultBlock:^(BOOL ischanged, NSInteger indexpathSection) {
            if (ischanged) {
                [weakSelf getPersonalData:nil];
            }
        }];
        [self.navigationController pushViewController:personalHealthyC animated:YES];
    }
}

#pragma mark - Action
// 报告按钮点击
- (void)reportBtnClicked:(CustomButton *)sender
{
    CustomerTest* selectCustomerTest = ((HistoryModel *)_historyArray[sender.tag]).customer;
    [HMNetworkEngine getInstance].delegate = self;
    [[HMNetworkEngine getInstance] getReportQueryUrl:selectCustomerTest.checkCode];
}


#pragma mark - HMNetworkEngineDelegate
-(void)reportResultReturnUrlPacketSucceed:(NSString*)urlStr
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    //[[UIApplication sharedApplication] openURL:[NSURL urlWithString:urlStr];
}
#pragma mark -支付

#pragma mark -取消预约，在线支付，付款
- (void)cancelAppointBtnClicked:(UIButton *)sender
{
    HistoryModel *model = _historyArray[sender.tag];
    [RzAlertView showAlertViewControllerWithController:self title:@"提示" message:[NSString stringWithFormat:@"您确定要取消 %@ 的体检预约吗？", model.customer.custName] confirmTitle:@"确定" cancleTitle:@"点错了" handle:^(NSInteger flag) {
        if (flag != 0) {
            [self cancelChecked:sender.tag];
        }
    }];
}
// 取消预约
- (void)cancelChecked:(NSInteger )index
{
    HistoryModel *model = _historyArray[index];
    [[HttpNetworkManager getInstance]cancleCheckedCustomerTestWithCheckCode:model.customer.checkCode resultBlock:^(BOOL result, NSError *error) {
        if (!error) {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"取消预约成功" removeDelay:2];
            [self.historyArray removeObjectAtIndex:index];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:index];
            [self.tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationLeft];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
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
    pay.checkCode = ((HistoryModel *)_historyArray[sender.tag]).customer.checkCode;
    pay.cityName = ((HistoryModel *)_historyArray[sender.tag]).customer.cityName;
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

    [self getPersonalData:nil]; // 刷新
}
/**
 *  支付取消
 */
- (void)payMoneyCencel{

    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您取消了支付" removeDelay:2];

    [self getPersonalData:nil]; // 刷新
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
