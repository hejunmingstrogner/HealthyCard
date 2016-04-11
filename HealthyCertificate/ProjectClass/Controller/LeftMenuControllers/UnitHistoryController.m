//
//  UnitHistoryController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UnitHistoryController.h"
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
#import "HistoryModel.h"
#import "CloudAppointmentCompanyViewController.h"
#import "DJRefresh.h"
#import "UnitCheckListTableviewCell.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)
@interface UnitHistoryController ()<UITableViewDataSource, UITableViewDelegate,HMNetworkEngineDelegate, DJRefreshDelegate>
{
    RzAlertView *waitAlertView;

    DJRefresh  *_refresh;
}


@end

@implementation UnitHistoryController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];
}

- (void)getData:(DJRefresh *)refresh{

    if (!waitAlertView) {
        waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"数据加载中..."];
    }
    [waitAlertView show];
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        _historyArray = [[NSMutableArray alloc]init];
        if (!error) {
            if (brContractArray.count != 0) {
                [self initCompanyDataArray:brContractArray type:HISTORY_UNIT_UNFINISHED];
            }
        }
        else {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"获取未完成项失败，请检查网络后重试" removeDelay:2];
        }

        [[HttpNetworkManager getInstance]findBRContractHistoryRegByCustomId:gUnitInfo.unitCode resuleBlock:^(NSArray *result, NSError *error) {
            if (!error) {
                if (result.count != 0) {
                    [self initCompanyDataArray:brContractArray type:HISTORY_UNIT_FINISHED];
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

- (void)initCompanyDataArray:(NSArray *)brcontractArray type:(HISTORY_TYPE)type
{
    for (BRContract *brContract in brcontractArray) {
        NSInteger rows;
        if ([brContract.testStatus isEqualToString:@"-1"] && type == HISTORY_UNIT_UNFINISHED) {
            rows = 5;
        }
        else {
            rows = 4;
        }
        HistoryModel *model = [[HistoryModel alloc]initWithCustomer:nil BRContract:brContract type:type rows:rows];
        [_historyArray addObject:model];
    }
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

- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction
{
    [self getData:refresh];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
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
#warning 单位预约取消订单
//    return ((HistoryModel *)_historyArray[indexPath.section]).rows *35;
    return 35*4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryModel *model = _historyArray[indexPath.section];
    UnitCheckListTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unitCell"];
    if (!cell) {
        cell = [[UnitCheckListTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unitCell"];
        [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.brContract = model.brContract;
    cell.cancelOrderBtn.tag = indexPath.section;
    if(model.type == HISTORY_UNIT_FINISHED){
        cell.cancelOrderBtn.hidden = YES;
    }
#warning 单位预约取消订单
    cell.cancelOrderBtn.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 单位预约点击
    HistoryModel *model = _historyArray[indexPath.section];
    if (model.type == HISTORY_UNIT_UNFINISHED) {
        // 未完成
        __weak typeof(self) weakself = self;
        CloudAppointmentCompanyViewController* companyViewController = [[CloudAppointmentCompanyViewController alloc] init];
        companyViewController.brContract = model.brContract;
        [companyViewController changedInformationWithResultBlock:^(BOOL ischanged, NSIndexPath *indexpath) {
            if (ischanged) {
                [weakself getData:nil];
            }
        }];
        [self.navigationController pushViewController:companyViewController animated:YES];
    }
    else {
        ContractPersonInfoViewController* contractVc = [[ContractPersonInfoViewController alloc] init];
        contractVc.brContract = model.brContract;
        [self.navigationController pushViewController:contractVc animated:YES];
    }
}

#pragma mark - Action
// 报告按钮点击
- (void)reportBtnClicked:(CustomButton *)sender
{
    CustomerTest* selectCustomerTest = (CustomerTest *)_historyArray[sender.tag];
    [HMNetworkEngine getInstance].delegate = self;
    [[HMNetworkEngine getInstance] getReportQueryUrl:selectCustomerTest.checkCode];
}


#pragma mark - HMNetworkEngineDelegate
-(void)reportResultReturnUrlPacketSucceed:(NSString*)urlStr
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    //[[UIApplication sharedApplication] openURL:[NSURL urlWithString:urlStr];
}


#pragma mark -取消订单
- (void)cancelOrderBtnClicked:(UIButton *)sender
{
    HistoryModel *model = _historyArray[sender.tag];
    [RzAlertView showAlertViewControllerWithController:self title:@"提示" message:model.brContract.unitName confirmTitle:@"确定" cancleTitle:@"点错了" handle:^(NSInteger flag) {
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
