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
    UserinformationCellItem *head = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"头像" detialLabelText:nil itemtype:USERINFORMATION_HEADERIMAGE];
    UserinformationCellItem *name = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"姓名" detialLabelText:@"与长江" itemtype:USERINFORMATION_NAME];
    UserinformationCellItem *sex = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"性别" detialLabelText:@"男" itemtype:USERINFORMATION_GENDER];
    UserinformationCellItem *old = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"年龄" detialLabelText:@"24" itemtype:USERINFORMATION_OLD];
    UserinformationCellItem *telPhoneNo = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"手机号" detialLabelText:@"18380446542" itemtype:USERINFORMATION_TELPHONENO];
    UserinformationCellItem *idCard = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"身份证号" detialLabelText:@"510921199612545111" itemtype:USERINFORMATION_IDCARD];
    UserinformationCellItem *calling = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"行业" detialLabelText:@"其他" itemtype:USERINFORMATION_CALLING];
    UserinformationCellItem *workUnit = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位名称" detialLabelText:@"成都信息工程学院" itemtype:USERINFORMATION_WORKUNITNAME];

    _dataArray = [NSMutableArray arrayWithObjects:head, name, sex, old, telPhoneNo, idCard, calling, workUnit, nil];

    // 单位
//    UserinformationCellItem *workUnitAdress = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位地址" detialLabelText:@"成都信息工程学院" itemtype:USERINFORMATION_WORKUNITADRESS];
//    UserinformationCellItem *workUnitName = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位名称" detialLabelText:@"成都信息工程学院" itemtype:USERINFORMATION_WORKUNITNAME];
//    UserinformationCellItem *workUnitContacts = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"单位联系人" detialLabelText:@"成都信息工程学院" itemtype:USERINFORMATION_WORKUNITCONTACTS];
//    UserinformationCellItem *workUnitTelPhone = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"手机号" detialLabelText:@"成都信息工程学院" itemtype:USERINFORMATION_TELPHONENO];
//    UserinformationCellItem *workUnitcalling = [[UserinformationCellItem alloc]initWithiconName:nil titleLabelText:@"行业" detialLabelText:@"成都信息工程学院" itemtype:USERINFORMATION_CALLING];
//    _dataArray = [NSMutableArray arrayWithObjects:workUnitAdress, workUnitName, workUnitContacts, workUnitContacts, workUnitTelPhone, workUnitcalling, nil];
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
    if (((UserinformationCellItem *)_dataArray[indexPath.row]).itemType == USERINFORMATION_HEADERIMAGE) {
        UITableViewCell *headcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
        headcell.textLabel.text = ((UserinformationCellItem *)_dataArray[indexPath.row]).titleLabelText;
        UIButton *headeimageBtn = [[UIButton alloc]init];
        [headcell.contentView addSubview:headeimageBtn];
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
    [self.navigationController pushViewController:setingController animated:YES];
}

@end
