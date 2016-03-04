//
//  UserInformationController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UserInformationController.h"
#import <UIImageView+WebCache.h>

#import "RzAlertView.h"
#import "HCWheelView.h"
#import "HttpNetworkManager.h"
#import "TakePhoto.h"

#import "UserinformationCellItem.h"
#import "SelectCompanyViewController.h"

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface UserInformationController()<UITableViewDataSource, UITableViewDelegate, HCWheelViewDelegate>
{
    HCWheelView *wheelView;
    RzAlertView *waitAlertView;
}
@end

@implementation UserInformationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self getdata];
    [self initSubviews];

    wheelView = [[HCWheelView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/3)];
    wheelView.pickerViewContentArr = [NSMutableArray arrayWithArray:@[@"男", @"女"]];
    wheelView.delegate = self;
    [self.view addSubview:wheelView];
}

- (void)initNavgation
{
    self.title = @"基本信息";
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


- (void)initSubviews
{
    //_dataArray = [[NSMutableArray alloc]init];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"图片上传中..."];
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
        _dataArray = [NSMutableArray arrayWithObjects:workUnitAdress, workUnitName, workUnitContacts, workUnitTelPhone, workUnitcalling, nil];
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
        headcell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
        UIButton *headeimageBtn = [[UIButton alloc]init];
        NSString *str = [NSString stringWithFormat:@"%@customer/getPhoto?cCustCode=%@", [HttpNetworkManager baseURL], gPersonInfo.mCustCode];
        [headeimageBtn sd_setImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headimage"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
        [headcell.contentView addSubview:headeimageBtn];
        [headeimageBtn addTarget:self action:@selector(headerimageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headeimageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headcell).offset(10);
            make.bottom.equalTo(headcell).offset(-10);
            make.right.equalTo(headcell).offset(-10);
            make.width.equalTo(headeimageBtn.mas_height);
        }];
        headeimageBtn.layer.masksToBounds = YES;
        headeimageBtn.layer.cornerRadius = 25;
        return headcell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
        cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
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
        }
        case USERINFORMATION_NAME:{
            break;
        }
        case USERINFORMATION_GENDER:{
            [UIView animateWithDuration:0.5 animations:^{
                wheelView.frame = CGRectMake(0, self.view.frame.size.height - self.view.frame.size.height/3, self.view.frame.size.width, self.view.frame.size.height/3);
            }];
            return;
        }
        case USERINFORMATION_OLD:{
            return;
        }
        case USERINFORMATION_TELPHONENO:{
            return;
        }
        case USERINFORMATION_IDCARD:{
            break;
        }
        case USERINFORMATION_CALLING:{
            return;
        }
        case USERINFORMATION_WORKUNITNAME:{
            if (GetUserType == 1) {
                SelectCompanyViewController *select = [[SelectCompanyViewController alloc]init];
                select.companyName = ((UserinformationCellItem *)_dataArray[indexPath.row]).detialLabelText;
                [select isupdataCompany:^(NSString *text) {
                    [self getdata];
                    [_tableView reloadData];
                }];
                [self.navigationController pushViewController:select animated:YES];
                return;
            }
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
    setingController.cacheFlag = ((UserinformationCellItem *)_dataArray[indexPath.row]).detialLabelText;
    setingController.itemtype = ((UserinformationCellItem *)_dataArray[indexPath.row]).itemType;

    // 如果修改了信息，并且修改成功，则刷新列表
    [setingController isUpdateInfoSucceed:^(BOOL successed, NSString *updataText) {
        [self updataSuccessThenChangeUserinformation:indexPath.row Text:updataText];
    }];
    
    [self.navigationController pushViewController:setingController animated:YES];
}
// 修改成功之后，改变本地数据
- (void)updataSuccessThenChangeUserinformation:(NSInteger)index Text:(NSString *)text
{
    switch (((UserinformationCellItem *)_dataArray[index]).itemType) {
        case USERINFORMATION_HEADERIMAGE:{
            break;
        }
        case USERINFORMATION_NAME:{
            gPersonInfo.mCustName = text;
            break;
        }
        case USERINFORMATION_GENDER:{
            break;
        }
        case USERINFORMATION_OLD:{
            return;
        }
        case USERINFORMATION_TELPHONENO:{
            break;
        }
        case USERINFORMATION_IDCARD:{
            gPersonInfo.CustId = text;
            break;
        }
        case USERINFORMATION_CALLING:{
            break;
        }
        case USERINFORMATION_WORKUNITNAME:{
            if (GetUserType == 1) {
                gPersonInfo.cUnitName = text;
            }
            else {
                gCompanyInfo.cUnitName = text;
            }
            break;
        }
        case USERINFORMATION_WORKUNITADRESS:{
            gCompanyInfo.cUnitAddr = text;
            break;
        }
        case USERINFORMATION_WORKUNITCONTACTS:{
            gCompanyInfo.cLinkPeople = text;
            break;
        }
        default:
            return;
    }
    [self getdata];
    [_tableView reloadData];

    if ([_delegate respondsToSelector:@selector(reloadLeftMenuViewByChangedUserinfor)] && _delegate) {
        [_delegate reloadLeftMenuViewByChangedUserinfor];
    }
}
#pragma mark -点击头像 设置头像
- (void)headerimageBtnClicked:(UIButton *)sender
{
    [[TakePhoto getInstancetype]takePhotoFromCurrentController:self WithRatioOfWidthAndHeight:3.0/4.0 resultBlock:^(UIImage *photoimage) {
        if(photoimage){
            [waitAlertView show];
            [[HttpNetworkManager getInstance]customerUploadPhoto:photoimage resultBlock:^(BOOL result, NSError *error) {
                [waitAlertView close];
                if (result) {
                    [sender setImage:photoimage forState:UIControlStateNormal];
                    // 刷新左侧菜单的头像
                    if ([_delegate respondsToSelector:@selector(reloadLeftMenuViewByChangedUserinfor)] && _delegate) {
                        [_delegate reloadLeftMenuViewByChangedUserinfor];
                    }
                }
                else {
                    [RzAlertView showAlertLabelWithTarget:self.view Message:@"上传失败,请稍候重试" removeDelay:2];
                }
            }];
        }
    }];
}

- (void)sureBtnClicked:(NSString *)wheelText
{
    // 改变性别
    int flag;
    if([wheelText isEqualToString:@"男"]){
        flag = 0;
    }
    else
        flag = 1;

    if (flag != gPersonInfo.bGender) {
        NSMutableDictionary *personinfo = [[NSMutableDictionary alloc]init];
        [personinfo setObject:gPersonInfo.mCustCode forKey:@"custCode"];
        [personinfo setObject:[NSNumber numberWithInt:flag] forKey:@"sex"];
        [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:personinfo resultBlock:^(BOOL successed, NSError *error) {
            if (successed) {
                gPersonInfo.bGender = flag;
                [self getdata];
                [_tableView reloadData];
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:2];
            }
            else {
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改失败，请检查网络后重试" removeDelay:2];
            }
        }];
    }

    [UIView animateWithDuration:0.5 animations:^{
        wheelView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/3);
    }];

}

- (void)cancelButtonClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        wheelView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/3);
    }];
}
@end
