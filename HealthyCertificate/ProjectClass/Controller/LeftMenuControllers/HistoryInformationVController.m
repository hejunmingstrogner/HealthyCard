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

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface HistoryInformationVController ()<UITableViewDataSource, UITableViewDelegate,HMNetworkEngineDelegate>
{
    RzAlertView *waitAlertView;
    NSMutableArray *_companyDataArray;
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
    if (_userType == 1) {
        [[HttpNetworkManager getInstance]findCustomerTestHistoryRegByCustomId:gPersonInfo.mCustCode resuluBlock:^(NSArray *result, NSError *error) {
            [waitAlertView close];
            if (!error) {
                if (result.count != 0) {
                    _historyArray = [[NSMutableArray alloc]initWithArray:result];
                    [_tableView reloadData];
                }
                else {
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"没有个人历史记录" removeDelay:3];
                }
            }
            else {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"数据加载出错，请稍候重试" removeDelay:3];
            }
        }];
    }
    else if(_userType == 2) {
        [[HttpNetworkManager getInstance]findBRContractHistoryRegByCustomId:gCompanyInfo.cUnitCode resuleBlock:^(NSArray *result, NSError *error) {
            [waitAlertView close];
            if (!error) {
                if (result.count != 0) {
                    _historyArray = [[NSMutableArray alloc]initWithArray:result];
                    [self initCompanyDataArray];
                    [_tableView reloadData];
                }
                else {
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"没有历史记录" removeDelay:3];
                }
            }
            else {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"数据加载出错，请稍候重试" removeDelay:3];
            }
        }];
    }
}

- (void)initCompanyDataArray
{
    _companyDataArray = [[NSMutableArray alloc]init];
    for (BRContract *brContract in _historyArray) {
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
    _tableView.separatorStyle = NO;
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _historyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_userType == 2)
    {
        return 4;
    }
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
    if(_userType == 1){
        return 110;
    }
    else {
        return 35;
    }
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
//            BRContractHistoryTBHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellheader"];
//            if (!cell) {
//                cell = [[BRContractHistoryTBHeaderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellheader"];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            [cell setBrContract:(BRContract *)_historyArray[indexPath.section]];
//            return cell;
//        }
//        else {
//            BRContractHistoryTBFootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellfoot"];
//            if (!cell ) {
//                cell = [[BRContractHistoryTBFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellfoot"];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            [cell setBrContract:(BRContract *)_historyArray[indexPath.section]];
//            return cell;
//        }
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
                cell.orderedLabel.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setCellItem:(BRContract *)_historyArray[indexPath.section]];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 个人
    if (_userType == 1) {
        PersonalHealthyCHistoryVC *person = [[PersonalHealthyCHistoryVC alloc]init];
        person.customerTestInfo = _historyArray[indexPath.section];
        [self.navigationController pushViewController:person animated:YES];
    }
    else {
        // 单位预约点击
        if (_userType == 2) {
            //customerTest/findByContract
            BRContract* brContract = _historyArray[indexPath.section];
            ContractPersonInfoViewController* contractVc = [[ContractPersonInfoViewController alloc] init];
            contractVc.brContract = brContract;
            [self.navigationController pushViewController:contractVc animated:YES];
        }
    }
}

#pragma mark - Action
// 报告按钮点击
- (void)reportBtnClicked:(CustomButton *)sender
{
    CustomerTest* selectCustomerTest = (CustomerTest *)_historyArray[sender.tag];
    [HMNetworkEngine getInstance].delegate = self;
    [[HMNetworkEngine getInstance] getReportQueryUrl:selectCustomerTest.checkCode];
    //NSLog(@"报告：%d", sender.tag);
}


#pragma mark - HMNetworkEngineDelegate
-(void)reportResultReturnUrlPacketSucceed:(NSString*)urlStr
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    //[[UIApplication sharedApplication] openURL:[NSURL urlWithString:urlStr];
}

@end
