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

#import "PCheckAllPayView.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface PersonalCheckListViewContrller()<DJRefreshDelegate, PayMoneyDelegate, PCheckAllPayViewDelegate>
{
    DJRefresh  *_refresh;
    NSInteger  payIndexPathSection;

    PCheckAllPayView *piliangzhifuView;     // 批量支付的界面

    NSInteger  countForPayMoneySum;      // 需要支付的人的总数
    UIButton * piliangPayBtn;
}

@property (nonatomic, assign, getter=isRefreshing) BOOL isRefreshing;

@property (nonatomic, strong) NSMutableDictionary *selectedListDic;   // 选中的要批量支付的数据

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

#warning 单位预约取消订单
    // 批量支付
    piliangPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
        // 当前设置为 去勾选
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        sender.tag = 1;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-61);
        }];

        // 获取单价
        for (CustomerTest *customertest in _checkDataArray) {
            [customertest getNeedMoneyWhenPayFor];
        }

        [self.tableView setEditing:YES animated:YES];
    }
    else {
        // 取消编辑状态
        [sender setTitle:@"批量支付" forState:UIControlStateNormal];
        sender.tag = 0;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        // 将已经选择过的批量支付重新归0
        [_selectedListDic removeAllObjects];
        [self setPCheckViewData];

        [self.tableView setEditing:NO animated:YES];
    }
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
    _selectedListDic = [[NSMutableDictionary alloc]init];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    _tableView.dataSource = self;
    _tableView.delegate = self;

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];

    piliangzhifuView = [[PCheckAllPayView alloc]init];
    piliangzhifuView.delegate = self;
    [self.view addSubview:piliangzhifuView];
    [piliangzhifuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.left.right.equalTo(_tableView);
        make.height.equalTo(@60);
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
            // 设置批量支付的各种状态
            [self setcancleOrder];
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
    [RzAlertView ShowWaitAlertWithTitle:@"刷新中..."];
    __weak typeof(self) weakself = self;
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        [RzAlertView CloseWaitAlert];
        if (!error) {
            weakself.checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];
            if (indexpathSection == -2) {   // 批量支付
                [weakself.tableView reloadData];

                // 设置批量支付的各种状态
                [self setcancleOrder];
            }
            else {
                NSIndexSet *indexset = [[NSIndexSet alloc]initWithIndex:indexpathSection];
                [weakself.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
        else {
            [RzAlertView showAlertLabelWithTarget:weakself.view Message:@"刷新失败，请检查网络后重试" removeDelay:2];
        }
    }];
}

#warning 单位预约取消订单
//  取消订单的设置 刷新过后的状态ßß
- (void)setcancleOrder
{
    countForPayMoneySum = 0;
    for (CustomerTest *cus in _checkDataArray) {
        if (cus.payMoney <=0 && [cus.testStatus isEqualToString:@"-1"]) {
            countForPayMoneySum++;
        }
    }
    piliangzhifuView.allCount = countForPayMoneySum;
    // 如果批量支付的界面当前已经显示了，则需要关闭
    piliangPayBtn.tag = 1;
    [self rightBtnClicked:piliangPayBtn];
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
    CustomerTest *customertest = (CustomerTest *)_checkDataArray[indexPath.section];
    if(_tableView.editing){
        NSLog(@"编辑状态");
        [_selectedListDic setObject:indexPath forKey:[NSNumber numberWithInteger:indexPath.section]];
        // 去设置批量支付view的数据
        [self setPCheckViewData];
        return;
    }
    // 进入个人待处理项界面
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    // 个人

    PersonalHealthyCController *personalHealthyC = [[PersonalHealthyCController alloc]init];
    personalHealthyC.customerTestInfo = customertest;
    [personalHealthyC changedInformationWithResultBlock:^(BOOL ischanged, NSInteger indexpathSection) {
        if (ischanged) {
            [weakSelf refreshNewDataWithIndexPathSection:indexPath.section];
        }
    }];
    [self.navigationController pushViewController:personalHealthyC animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_selectedListDic removeObjectForKey:[NSNumber numberWithInteger:indexPath.section]];
    // 去设置批量支付view的数据
    [self setPCheckViewData];
}
// 去设置批量支付view的数据
- (void)setPCheckViewData
{
#warning 获取单价
    // 获取总价
    NSArray *index = [_selectedListDic allKeys];
    float money = 0;
    BOOL flag = YES;
    for (NSNumber *i in index) {
        if (((CustomerTest *)_checkDataArray[[i integerValue]]).needMoney <= 0) {
            flag = NO;
            NSString *message = [NSString stringWithFormat:@"没有获取到 %@ %@ 的体检单价\n请检查网络后重试", ((CustomerTest *)_checkDataArray[[i integerValue]]).custName, ((CustomerTest *)_checkDataArray[[i integerValue]]).cityName];
            [RzAlertView showAlertViewControllerWithViewController:self title:@"提示" Message:message ActionTitle:@"重试" ActionStyle:UIAlertActionStyleDefault handle:^(NSInteger flag) {
                [[HttpNetworkManager getInstance]getCustomerTestChargePriceWithCityName:((CustomerTest *)_checkDataArray[[i integerValue]]).cityName checkType:nil resultBlcok:^(NSString *result, NSError *error) {
                    if (!error) {
                        ((CustomerTest *)_checkDataArray[[i integerValue]]).needMoney = [result floatValue];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setPCheckViewData];
                    });
                }];
            }];
        }
        else {
            money += ((CustomerTest *)_checkDataArray[[i integerValue]]).needMoney;
        }
    }
    if (flag) {
        // 设置单价，交钱的人数
        [piliangzhifuView setMoney:money count:_selectedListDic.count];
    }

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

#pragma mark -批量支付的delegate
// 去批量支付
-(void)payAll
{
    NSLog(@"去批量支付");
    NSArray *index = [_selectedListDic allKeys];
    NSMutableArray *customers = [[NSMutableArray alloc]init];
    for (NSNumber *i in index) {
        [customers addObject:(CustomerTest *)_checkDataArray[[i integerValue]]];
    }
    if(customers.count == 0)
    {
        [RzAlertView showAlertLabelWithMessage:@"请选择支付对象" removewDelay:2];
        return;
    }
    PayMoneyController *pay = [[PayMoneyController alloc]init];
    pay.chargetype = BatchCharge;
    pay.delegate = self;
    pay.CustomerTestArray = customers;
    payIndexPathSection = -2;
    [self.navigationController pushViewController:pay animated:YES];
}
// 全选
- (void)selectAll{
    [_selectedListDic removeAllObjects];
    for (int i = 0; i < _checkDataArray.count; i++) {
        CustomerTest *customertest = (CustomerTest *)_checkDataArray[i];
        if (customertest.payMoney <= 0 && [customertest.testStatus isEqualToString:@"-1"]) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:i];
            [_tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [_selectedListDic setObject:indexpath forKey:[NSNumber numberWithInteger:indexpath.section]];
        }
    }
    [self setPCheckViewData];
}
// 取消全选
- (void)deSelectAll
{
    [_selectedListDic removeAllObjects];
    [_tableView reloadData];
    [self setPCheckViewData];
}
@end

