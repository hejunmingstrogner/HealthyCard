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
#import "UIColor+Expanded.h"

#import "WorkTypeViewController.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#define CELL_FONT FIT_FONTSIZE(24)

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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [UIView animateWithDuration:0.5 animations:^{
        wheelView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/3);
    }];
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
        UserinformationCellItem *head = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"头像" detialLabelText:nil itemtype:PERSON_HEADERIMAGE];
        UserinformationCellItem *name = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"姓名" detialLabelText:[gPersonInfo.mCustName isEqualToString:@""] ? @"暂无":gPersonInfo.mCustName itemtype:PERSON_NAME];
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
        UserinformationCellItem *sex = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"性别" detialLabelText:bGender itemtype:PERSON_GENDER];
        UserinformationCellItem *old = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"年龄" detialLabelText:[NSString getOldYears:gPersonInfo.CustId] itemtype:PERSON_AGE];
        UserinformationCellItem *telPhoneNo = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"手机号" detialLabelText:[gPersonInfo.StrTel isEqualToString:@""] ? @"暂无" : gPersonInfo.StrTel itemtype:PERSON_TELPHONE];
        UserinformationCellItem *idCard = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"身份证号" detialLabelText:[gPersonInfo.CustId isEqualToString:@""] ? @"暂无" : gPersonInfo.CustId itemtype:PERSON_IDCARD];
        UserinformationCellItem *calling = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"从事行业" detialLabelText:[gPersonInfo.cIndustry isEqualToString:@""] ? @"暂无" : gPersonInfo.cIndustry itemtype:PERSON_CALLING];
        UserinformationCellItem *workUnit = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位名称" detialLabelText:[gPersonInfo.cUnitName isEqualToString:@""] ? @"暂无" : gPersonInfo.cUnitName itemtype:PERSON_COMPANY_NAME];

        _dataArray = [NSMutableArray arrayWithObjects:head, name, sex, old, telPhoneNo, idCard, calling, workUnit, nil];
    }
    else{
        // 单位
        UserinformationCellItem *workUnitName = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位名称" detialLabelText:[gCompanyInfo.cUnitName isEqualToString:@""] ? @"暂无" : gCompanyInfo.cUnitName itemtype:COMPANY_NAME];
        UserinformationCellItem *workUnitAdress = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位地址" detialLabelText:[gCompanyInfo.cUnitAddr isEqualToString:@""] ? @"暂无" : gCompanyInfo.cUnitAddr itemtype:COMPANY_ADDRESS];
        UserinformationCellItem *workUnitContacts = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位联系人" detialLabelText:[gCompanyInfo.cLinkPeople isEqualToString:@""] ? @"暂无" : gCompanyInfo.cLinkPeople itemtype:COMPANY_CONTACT];
        UserinformationCellItem *workUnitTelPhone = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"手机号" detialLabelText:[gCompanyInfo.cLinkPhone isEqualToString:@""] ? @"暂无" : gCompanyInfo.cLinkPhone itemtype:COMPANY_LINKPHONE];
        UserinformationCellItem *workUnitcalling = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"从事行业" detialLabelText:[gCompanyInfo.cUnitType isEqualToString:@""] ? @"暂无" : gCompanyInfo.cUnitType itemtype:COMPANY_CALLING];
        _dataArray = [NSMutableArray arrayWithObjects:workUnitName, workUnitAdress, workUnitContacts, workUnitTelPhone, workUnitcalling, nil];
    }
}


#pragma mark - UITableViewDataSource & UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (((UserinformationCellItem *)_dataArray[indexPath.row]).itemType == PERSON_HEADERIMAGE) {
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
    if (((UserinformationCellItem *)_dataArray[indexPath.row]).itemType == PERSON_HEADERIMAGE) {
        UITableViewCell *headcell = [[UITableViewCell alloc]init];
        headcell.textLabel.text = ((UserinformationCellItem *)_dataArray[indexPath.row]).titleLabelText;
        headcell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:CELL_FONT];
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
        cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:CELL_FONT];
        cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:CELL_FONT];
    }
    UserinformationCellItem* usefInformationCellItem = (UserinformationCellItem *)_dataArray[indexPath.row];
    cell.textLabel.text = usefInformationCellItem.titleLabelText;
    if (usefInformationCellItem.itemType == PERSON_AGE || usefInformationCellItem.itemType == PERSON_TELPHONE || usefInformationCellItem.itemType == COMPANY_LINKPHONE){
        cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    }else{
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    cell.detailTextLabel.text = usefInformationCellItem.detialLabelText;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserinformationCellItem* item = (UserinformationCellItem *)_dataArray[indexPath.row];
    switch (item.itemType) {
        case PERSON_HEADERIMAGE:{
            return;
        }
        case PERSON_NAME:{
            break;
        }
        case PERSON_GENDER:{
            if ([item.detialLabelText isEqualToString:@"女"]){
                [wheelView.pickerView selectRow:1 inComponent:0 animated:NO];
            }else{
                [wheelView.pickerView selectRow:0 inComponent:0 animated:NO];
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                wheelView.frame = CGRectMake(0, self.view.frame.size.height - self.view.frame.size.height/3, self.view.frame.size.width, self.view.frame.size.height/3);
            }];
            return;
        }
        case PERSON_AGE:{
            return;
        }
        case PERSON_TELPHONE:{
            return;
        }
        case PERSON_IDCARD:{
            break;
        }
        case PERSON_CALLING:{
            if (GetUserType == 1) {
                WorkTypeViewController *workType = [[WorkTypeViewController alloc]init];
                workType.workTypeStr = item.detialLabelText;
                workType.block = ^(NSString *resultStr){
                    // 修改行业
                    NSMutableDictionary *personinfo = [[NSMutableDictionary alloc]init];
                    [personinfo setObject:gPersonInfo.mCustCode forKey:@"custCode"];
                    [personinfo setObject:resultStr forKey:@"custType"];
                    [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:personinfo resultBlock:^(BOOL successed, NSError *error) {
                        if (!error) {
                            [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改行业成功" removeDelay:2];
                            gPersonInfo.cIndustry = resultStr;
                            [self getdata];
                            [_tableView reloadData];
                        }
                        else {
                            [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改行业失败，请重试" removeDelay:3];
                        }
                    }];
                };
                [self.navigationController pushViewController:workType animated:YES];
            }

            return;
        }
        case PERSON_COMPANY_NAME:{
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
        case COMPANY_NAME:{
            break;
        }
        case COMPANY_CALLING:{
            if(GetUserType == 2){
                WorkTypeViewController *workType = [[WorkTypeViewController alloc]init];
                workType.workTypeStr = item.detialLabelText;
                workType.block = ^(NSString *resultStr){
                    // 修改行业
                    NSMutableDictionary *company = [[NSMutableDictionary alloc]init];
                    [company setObject:gCompanyInfo.cUnitCode forKey:@"unitCode"];
                    [company setObject:resultStr forKey:@"unitType"];
                    [[HttpNetworkManager getInstance]createOrUpdateBRServiceInformationwithInfor:company resultBlock:^(BOOL successed, NSError *error) {
                        if (!error) {
                            [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改行业成功" removeDelay:2];
                            gCompanyInfo.cUnitType = resultStr;
                            [self getdata];
                            [_tableView reloadData];
                        }
                        else {
                            [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改行业失败，请重试" removeDelay:3];
                        }
                    }];
                };
                [self.navigationController pushViewController:workType animated:YES];
            }
            return;
        }

        case COMPANY_ADDRESS:{
            break;
        }
        case COMPANY_CONTACT:{
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
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:1];
    switch (((UserinformationCellItem *)_dataArray[index]).itemType) {
        case PERSON_HEADERIMAGE:{
            break;
        }
        case PERSON_NAME:{
            gPersonInfo.mCustName = text;
            break;
        }
        case PERSON_GENDER:{
            break;
        }
        case PERSON_AGE:{
            return;
        }
        case PERSON_TELPHONE:{
            break;
        }
        case PERSON_IDCARD:{
            gPersonInfo.CustId = text;
            break;
        }
        case PERSON_CALLING:{
            break;
        }
        case PERSON_COMPANY_NAME:{
            if (GetUserType == 1) {
                gPersonInfo.cUnitName = text;
            }
            break;
        }
        case COMPANY_NAME:{
            if (GetUserType == 2) {
                gCompanyInfo.cUnitName = text;
            }
            break;
        }
        case COMPANY_ADDRESS:{
            gCompanyInfo.cUnitAddr = text;
            break;
        }
        case COMPANY_CONTACT:{
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
                    //[sender setImage:photoimage forState:UIControlStateNormal];
                    [_tableView reloadData];
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
