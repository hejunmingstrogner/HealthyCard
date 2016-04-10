//
//  UnitCheckListVIewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UnitCheckListVIewController.h"

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

@interface UnitCheckListVIewController()<DJRefreshDelegate, UITableViewDelegate, UITableViewDataSource>
{
    DJRefresh  *_refresh;
    RzAlertView *waitAlertView;
    NSInteger  payIndexPathSection;
}

@property (nonatomic, assign, getter=isRefreshing) BOOL isRefreshing;

@end

@implementation UnitCheckListVIewController

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
            weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];

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
            weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];

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
    if ([((BRContract *)_checkDataArray[indexPath.section]).testStatus isEqualToString:@"-1"]) {
        return 35*5;
    }
    return 35*4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitCheckListTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unitCell"];
    if (!cell) {
        cell = [[UnitCheckListTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unitCell"];
        [cell.cancelOrderBtn addTarget:self action:@selector(cancleUnitOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.brContract = _checkDataArray[indexPath.section];
    cell.cancelOrderBtn.tag = indexPath.section;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    CloudAppointmentCompanyViewController* companyViewController = [[CloudAppointmentCompanyViewController alloc] init];
    companyViewController.brContract = _checkDataArray[indexPath.section];
    [companyViewController changedInformationWithResultBlock:^(BOOL ischanged, NSIndexPath *indexpath) {
        if (ischanged) {
            [weakSelf refreshNewDataWithIndexPathSection:indexPath.section];
        }
    }];
    [self.navigationController pushViewController:companyViewController animated:YES];
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
