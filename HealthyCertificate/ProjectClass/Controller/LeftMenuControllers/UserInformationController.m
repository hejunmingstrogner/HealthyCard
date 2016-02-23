//
//  UserInformationController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UserInformationController.h"
#import "RzAlertView.h"
#import "UserinformationCellItem.h"
#import <UIImageView+WebCache.h>
#import "HttpNetworkManager.h"

@interface UserInformationController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation UserInformationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self getdata];
    [self initSubviews];
}

- (void)initNavgation
{
    self.title = @"基本信息";
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)initSubviews
{
    //_dataArray = [[NSMutableArray alloc]init];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)getdata
{
        // 个人
    if (GetUserType == 1) {
        UserinformationCellItem *head = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"头像" detialLabelText:nil itemtype:USERINFORMATION_HEADERIMAGE];
        UserinformationCellItem *name = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"姓名" detialLabelText:[gPersonInfo.mCustName isEqualToString:@""] ? @"暂无":gPersonInfo.mCustName itemtype:USERINFORMATION_NAME];
        NSString *bGender;
        if (gPersonInfo.bGender == 0) {
            bGender = @"男";
        }
        else if(gPersonInfo.bGender == 1){
            bGender = @"女";
        }
        else{
            bGender = @"暂无";
        }
        UserinformationCellItem *sex = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"性别" detialLabelText:bGender itemtype:USERINFORMATION_GENDER];
        UserinformationCellItem *old = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"年龄" detialLabelText:[NSString getOldYears:gPersonInfo.CustId] itemtype:USERINFORMATION_OLD];
        UserinformationCellItem *telPhoneNo = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"手机号" detialLabelText:[gPersonInfo.StrTel isEqualToString:@""] ? @"暂无" : gPersonInfo.StrTel itemtype:USERINFORMATION_TELPHONENO];
        UserinformationCellItem *idCard = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"身份证号" detialLabelText:[gPersonInfo.CustId isEqualToString:@""] ? @"暂无" : gPersonInfo.CustId itemtype:USERINFORMATION_IDCARD];
        UserinformationCellItem *calling = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"行业" detialLabelText:[gPersonInfo.cIndustry isEqualToString:@""] ? @"暂无" : gPersonInfo.cIndustry itemtype:USERINFORMATION_CALLING];
        UserinformationCellItem *workUnit = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位名称" detialLabelText:[gPersonInfo.cUnitName isEqualToString:@""] ? @"暂无" : gPersonInfo.cUnitName itemtype:USERINFORMATION_WORKUNITNAME];

        _dataArray = [NSMutableArray arrayWithObjects:head, name, sex, old, telPhoneNo, idCard, calling, workUnit, nil];
    }
    else{
        // 单位
        UserinformationCellItem *workUnitAdress = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位地址" detialLabelText:[gCompanyInfo.cUnitAddr isEqualToString:@""] ? @"暂无" : gCompanyInfo.cUnitAddr itemtype:USERINFORMATION_WORKUNITADRESS];
        UserinformationCellItem *workUnitName = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位名称" detialLabelText:[gCompanyInfo.cUnitName isEqualToString:@""] ? @"暂无" : gCompanyInfo.cUnitName itemtype:USERINFORMATION_WORKUNITNAME];
        UserinformationCellItem *workUnitContacts = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位联系人" detialLabelText:[gCompanyInfo.cLinkPeople isEqualToString:@""] ? @"暂无" : gCompanyInfo.cLinkPeople itemtype:USERINFORMATION_WORKUNITCONTACTS];
        UserinformationCellItem *workUnitTelPhone = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"手机号" detialLabelText:[gCompanyInfo.cLinkPhone isEqualToString:@""] ? @"暂无" : gCompanyInfo.cLinkPhone itemtype:USERINFORMATION_TELPHONENO];
        UserinformationCellItem *workUnitcalling = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"行业" detialLabelText:[gCompanyInfo.cUnitType isEqualToString:@""] ? @"暂无" : gCompanyInfo.cUnitType itemtype:USERINFORMATION_CALLING];
        _dataArray = [NSMutableArray arrayWithObjects:workUnitAdress, workUnitName, workUnitContacts, workUnitContacts, workUnitTelPhone, workUnitcalling, nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (((UserinformationCellItem *)_dataArray[indexPath.row]).itemType == USERINFORMATION_HEADERIMAGE) {
        return 70;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 有头像
    if (((UserinformationCellItem *)_dataArray[indexPath.row]).itemType == USERINFORMATION_HEADERIMAGE) {
        UITableViewCell *headcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
        headcell.textLabel.text = ((UserinformationCellItem *)_dataArray[indexPath.row]).titleLabelText;
        UIButton *headeimageBtn = [[UIButton alloc]init];

        [headeimageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@customer/getPhoto?cCustCode=%@", [HttpNetworkManager baseURL], gPersonInfo.mCustCode]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headimage"] options:SDWebImageRefreshCached];
        [headcell.contentView addSubview:headeimageBtn];
        [headeimageBtn addTarget:self action:@selector(headerimageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headeimageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headcell).offset(10);
            make.bottom.equalTo(headcell).offset(-10);
            make.right.equalTo(headcell).offset(-10);
            make.width.equalTo(headeimageBtn.mas_height);
        }];
        return headcell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = ((UserinformationCellItem *)_dataArray[indexPath.row]).titleLabelText;
    cell.detailTextLabel.text = ((UserinformationCellItem *)_dataArray[indexPath.row]).detialLabelText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (((UserinformationCellItem *)_dataArray[indexPath.row]).itemType) {
        case USERINFORMATION_HEADERIMAGE:{
            return;
            break;
        }
        case USERINFORMATION_NAME:{
            break;
        }
        case USERINFORMATION_GENDER:{
            return;
            break;
        }
        case USERINFORMATION_OLD:{
            return;
            break;
        }
        case USERINFORMATION_TELPHONENO:{
            return;
            break;
        }
        case USERINFORMATION_IDCARD:{
            break;
        }
        case USERINFORMATION_CALLING:{
            return;
            break;
        }
        case USERINFORMATION_WORKUNITNAME:{
            break;
        }
        case USERINFORMATION_WORKUNITADRESS:{
            break;
        }
        case USERINFORMATION_WORKUNITCONTACTS:{
            break;
        }
        default:
            return;
    }
    UserinformationSetingViewController *setingController = [[UserinformationSetingViewController alloc]init];
    setingController.itemtype = ((UserinformationCellItem *)_dataArray[indexPath.row]).itemType;

    // 如果修改了信息，并且修改成功，则刷新列表
    [setingController isUpdateInfoSucceed:^(BOOL successed) {
        if (successed) {
            [_tableView reloadData];
        }
    }];
    
    [self.navigationController pushViewController:setingController animated:YES];
}

#pragma mark -点击头像 设置头像
- (void)headerimageBtnClicked:(UIButton *)sender
{
    [RzAlertView showAlertViewControllerWithTarget:self Title:nil Message:nil preferredStyle:UIAlertControllerStyleActionSheet ActionTitlesArray:@[@"立即拍照", @"本地图片"] handle:^(NSInteger flag) {
        if (flag == 1) {
            NSLog(@"立即拍照");
        }
        else if (flag == 2){
            NSLog(@"本地图片");
        }
    }];
}

@end