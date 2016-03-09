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
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "BaseTBCellItem.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "DJRefresh.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface MyCheckListViewController()<DJRefreshDelegate>
{
    NSMutableArray *checkDataArray;
    DJRefresh  *_refresh;
}

@end

@implementation MyCheckListViewController

@synthesize checkDataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];
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

- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction
{
    [[HttpNetworkManager getInstance]getCheckListWithBlock:^(NSArray *customerArray, NSArray *brContractArray, NSError *error) {
        [refresh finishRefreshingDirection:direction animation:YES];
        if (!error) {
            if (_userType == 1) {
                checkDataArray = [[NSMutableArray alloc]initWithArray:customerArray];
            }
            else if (_userType == 2) {
                checkDataArray = [[NSMutableArray alloc]initWithArray:brContractArray];
                [self initCompanyDataArray];
            }
            [_tableView reloadData];
        }
        else {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"刷新失败，请检查网络后重试" removeDelay:2];
        }
    }];
}
- (void)initCompanyDataArray
{
    _companyDataArray = [[NSMutableArray alloc]init];
    for (BRContract *brContract in checkDataArray) {
        BaseTBCellItem *cellitem0 = [[BaseTBCellItem alloc]initWithTitle:@"单位名称" detial:brContract.unitName cellStyle:0];
        BaseTBCellItem *cellitem1 = [[BaseTBCellItem alloc]initWithTitle:@"服务地址" detial:brContract.servicePoint.address cellStyle:0];

        NSString *timestatus;
        if (brContract.checkSiteID == nil) {
            timestatus = @"现场体检";
        }
        else
        {
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
                timestatus = @"获取失败";
            }
        }
        BaseTBCellItem *cellitem2 = [[BaseTBCellItem alloc]initWithTitle:@"服务时间" detial:timestatus cellStyle:0];
        NSArray *array = @[cellitem0, cellitem1, cellitem2];
        [_companyDataArray addObject:array];
    }
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
        CustomerTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CustomerTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell setCellItemWithTest:(CustomerTest *)checkDataArray[indexPath.section]];
        return cell;
    }
    // 单位
    else{
        if (indexPath.row != 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brcell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"brcell"];
                cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
                cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
                //cell.detailTextLabel.textColor = [UIColor colorWithARGBHex:HC_Gray_Text];
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
            [cell setCellItem:(BRContract *)checkDataArray[indexPath.section]];
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
        personalHealthyC.customerTestInfo = (CustomerTest *)checkDataArray[indexPath.section];
        [self.navigationController pushViewController:personalHealthyC animated:YES];
    }
    else {
        // 单位预约点击
        if (_userType == 2) {
            CloudAppointmentCompanyViewController *cloudAppointCompany = [[CloudAppointmentCompanyViewController alloc]init];
            cloudAppointCompany.isCustomerServerPoint = NO;
            cloudAppointCompany.brContract = checkDataArray[indexPath.section];
            [self.navigationController pushViewController:cloudAppointCompany animated:YES];
        }
    }
}

@end
