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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    static int flag = 1;
//    if (flag == 1) {
//        flag ++;
//        return;
//    }
//    if ([self isRefreshing]) {
//        return;
//    }
//    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

- (void)initNavgation
{
    self.title = @"我的预约";
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

    if(_userType == 2){
        [self initCompanyDataArray];
    }

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

- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction
{
    _isRefreshing = YES;
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        _isRefreshing = NO;
        if (!error) {
            if (_userType == 1) {
                _checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];
            }
            else if (_userType == 2) {
                _checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];
                [self initCompanyDataArray];
            }
            [_tableView reloadData];
        }
        else {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"刷新失败，请检查网络后重试" removeDelay:2];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refresh finishRefreshingDirection:direction animation:YES];
        });
    }];
}

- (void)refreshNewDataWithIndexPathSection:(NSInteger )indexpathSection{
    if (!waitAlertView) {
        waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"刷新中..."];
    }
    [waitAlertView show];
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        [waitAlertView close];
        if (!error) {
            if (_userType == 1) {
                _checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];
            }
            else if (_userType == 2) {
                _checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];
                [self initCompanyDataArray];
            }
            NSIndexSet *indexset = [[NSIndexSet alloc]initWithIndex:indexpathSection];
            [_tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationLeft];
        }
        else {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"刷新失败，请检查网络后重试" removeDelay:2];
        }
    }];
}
- (void)initCompanyDataArray
{
    _companyDataArray = [[NSMutableArray alloc]init];
    for (BRContract *brContract in _checkDataArray) {
        BaseTBCellItem *cellitem0 = [[BaseTBCellItem alloc]initWithTitle:@"单位名称" detial:brContract.unitName cellStyle:0];
        BaseTBCellItem *cellitem1;
        BaseTBCellItem *cellitem2;
    
        //错误条件 checksideid 不为空 但 servicepoint为空
        BOOL conditionFirst = (brContract.checkSiteID != nil && ![brContract.checkSiteID isEqualToString:@""]) && (brContract.servicePoint == nil);
        if (conditionFirst)
        {
            //数据异常
            cellitem1 = [[BaseTBCellItem alloc]initWithTitle:@"体检地址" detial:@"获取失败" cellStyle:0];
            cellitem2 = [[BaseTBCellItem alloc]initWithTitle:@"体检时间" detial:@"获取失败" cellStyle:0];

        }
        else
        {
            cellitem1 = [[BaseTBCellItem alloc]initWithTitle:@"体检地址" detial:brContract.regPosAddr cellStyle:0];
            NSString *timestatus;
            
            if (brContract.servicePoint != nil) {
                if (!brContract.servicePoint.startTime || !brContract.servicePoint.endTime) {
                    timestatus = @"获取时间出错";
                }
                else {
                    NSString *year = [NSDate getYear_Month_DayByDate:brContract.servicePoint.startTime/1000];
                    NSString *start = [NSDate getHour_MinuteByDate:brContract.servicePoint.startTime/1000];
                    NSString *end = [NSDate getHour_MinuteByDate:brContract.servicePoint.endTime/1000];
                    timestatus = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
                }
            }
            else {
                NSString *year = [NSDate getYear_Month_DayByDate:brContract.regBeginDate/1000];
                NSString *end = [NSDate getYear_Month_DayByDate:brContract.regEndDate/1000];
                timestatus = [NSString stringWithFormat:@"%@~%@", year,end];
            }
            cellitem2 = [[BaseTBCellItem alloc]initWithTitle:@"体检时间" detial:timestatus cellStyle:0];

        }
        
        
       
        NSArray *array = @[cellitem0, cellitem1, cellitem2];
        [_companyDataArray addObject:array];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _checkDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_userType == 1) {
//        if (((CustomerTest *)_checkDataArray[section]).payMoney <= 0) {
//            return 2;
//        }
        return 2;
    }
    else if (_userType == 2){
        return 4;
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
            return 110;
        }
        return 35;
    }
    else {
        return 35;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 个人
    if (_userType == 1) {
        if (indexPath.row == 0) {
            CustomerTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[CustomerTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setCellItemWithTest:(CustomerTest *)_checkDataArray[indexPath.section]];
            return cell;
        }
        else {
            CheckListPayMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paycell"];
            if (!cell) {
                cell = [[CheckListPayMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paycell"];
                [cell.payMoneyBtn addTarget:self action:@selector(payMoneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.payMoneyBtn.tag = indexPath.section;
            cell.payMoney =((CustomerTest *)_checkDataArray[indexPath.section]).payMoney;
            return cell;
        }
    }
    // 单位
    else{
        if (indexPath.row != 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brcell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"brcell"];
                cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
                cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = ((BaseTBCellItem *)_companyDataArray[indexPath.section][indexPath.row]).titleText;
            cell.detailTextLabel.text = ((BaseTBCellItem *)_companyDataArray[indexPath.section][indexPath.row]).detialText;
            return cell;
        }
        else {
            BRContractTableFootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellfoot"];
            if (!cell ) {
                cell = [[BRContractTableFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellfoot"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setCellItem:(BRContract *)_checkDataArray[indexPath.section]];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 个人
    if (_userType == 1) {
        PersonalHealthyCController *personalHealthyC = [[PersonalHealthyCController alloc]init];
        personalHealthyC.customerTestInfo = (CustomerTest *)_checkDataArray[indexPath.section];
        [personalHealthyC changedInformationWithResultBlock:^(BOOL ischanged, NSInteger indexpathSection) {
            if (ischanged) {
                [self refreshNewDataWithIndexPathSection:indexPath.section];
            }
        }];
        [self.navigationController pushViewController:personalHealthyC animated:YES];
    }
    else if (_userType == 2){ // 单位预约点击
        CompanyAppointmentListViewController* companyAppointmentListViewController = [[CompanyAppointmentListViewController alloc] init];
        companyAppointmentListViewController.brContract = _checkDataArray[indexPath.section];
        //companyAppointmentListViewController.indexPath = indexPath;
        [companyAppointmentListViewController changedInformationWithResultBlock:^(BOOL ischanged, NSIndexPath *indexpath) {
            if (ischanged) {
                [self refreshNewDataWithIndexPathSection:indexPath.section];
            }
        }];
        [self.navigationController pushViewController:companyAppointmentListViewController animated:YES];
    }
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

@end
