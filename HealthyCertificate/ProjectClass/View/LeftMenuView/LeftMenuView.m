//
//  LeftMenuView.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "LeftMenuView.h"
#import <UIImageView+WebCache.h>
#import "HttpNetworkManager.h"
#import "LeftMenuViewHeaderinfoCell.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIColor+Expanded.h"
#import "Constants.h"

@interface LeftMenuView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation LeftMenuView

- (instancetype)init
{
    if (self = [super init]) {
        [self initWithSubViewsAndData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initWithSubViewsAndData];
    }
    return self;
}

// 初始化view和数据
- (void)initWithSubViewsAndData
{
    [self initData];
    UIView *bgview = [[UIView alloc]init];
    [self addSubview:bgview];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height) style:UITableViewStyleGrouped];
    [self addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView);
        make.bottom.equalTo(self);
    }];
}

- (void)initData
{
    // 个人
    LeftMenuCellItem *userinformation;
    LeftMenuCellItem *appoint;  // 预约
    LeftMenuCellItem *erweima;  // 二维码
    LeftMenuCellItem *manage;   // 单位注册或者员工管理
    if (GetUserType == 1) {
        userinformation = [[LeftMenuCellItem alloc]initWithiconName:@"headimage" titleLabelText:gPersonInfo.mCustName detialLabelText:gPersonInfo.StrTel itemtype:LEFTMENUCELL_USERINFOR];
        appoint = [[LeftMenuCellItem alloc]initWithiconName:@"historyRecord" titleLabelText:@"我的预约" detialLabelText:nil itemtype:LEFTMENUCELL_PERSON_APPOINT];
        erweima = [[LeftMenuCellItem alloc]initWithiconName:@"erweima" titleLabelText:@"我的二维码" detialLabelText:nil itemtype:LEFTMENUCELL_PERSON_ERWEIMA];
        manage = [[LeftMenuCellItem alloc]initWithiconName:@"danweizhuce" titleLabelText:@"单位注册" detialLabelText:nil itemtype:LEFTMENUCELL_PERSON_UNITLOGIN];

    }
    else if(GetUserType == 2)
    {
         userinformation = [[LeftMenuCellItem alloc]initWithiconName:@"headimage" titleLabelText:gCompanyInfo.cUnitName detialLabelText:gPersonInfo.StrTel itemtype:LEFTMENUCELL_USERINFOR];
        appoint = [[LeftMenuCellItem alloc]initWithiconName:@"historyRecord" titleLabelText:@"历史记录" detialLabelText:nil itemtype:LEFTMENUCELL_UNIT_APPOINT];
        erweima = [[LeftMenuCellItem alloc]initWithiconName:@"erweima" titleLabelText:@"单位二维码" detialLabelText:nil itemtype:LEFTMENUCELL_UNIT_ERWEIMA];
        manage = [[LeftMenuCellItem alloc]initWithiconName:@"danweiguanli" titleLabelText:@"员工管理" detialLabelText:nil itemtype:LEFTMENUCELL_UNIT_WORKERMANAGE];
    }
    LeftMenuCellItem *userType = [[LeftMenuCellItem alloc]initWithiconName:@"leixing" titleLabelText:@"用户类型" detialLabelText:nil itemtype:LEFTMENUCELL_USERTYPE];
    LeftMenuCellItem *notice = [[LeftMenuCellItem alloc]initWithiconName:@"notice" titleLabelText:@"注意事项" detialLabelText:nil itemtype:LEFTMENUCELL_NOTICE];
    LeftMenuCellItem *aboutUs = [[LeftMenuCellItem alloc]initWithiconName:@"aboutUs" titleLabelText:@"关于我们" detialLabelText:nil itemtype:LEFTMENUCELL_ABOUTUS];
    LeftMenuCellItem *advice = [[LeftMenuCellItem alloc]initWithiconName:@"advice" titleLabelText:@"意见或建议" detialLabelText:nil itemtype:LEFTMENUCELL_ADVICE];
    LeftMenuCellItem *exit = [[LeftMenuCellItem alloc]initWithiconName:@"exit" titleLabelText:@"退出当前账号" detialLabelText:nil itemtype:LEFTMENUCELL_EXIT];
    if((gCompanyInfo.cUnitCode.length == 0 && GetUserType == 1) || GetUserType == 2){
        _menuItemArray = [NSMutableArray arrayWithObjects:userinformation,appoint, erweima, manage, userType, notice, aboutUs, advice, exit, nil];
    }
    else {
        _menuItemArray = [NSMutableArray arrayWithObjects:userinformation,appoint, erweima, userType, notice, aboutUs, advice, exit, nil];
    }

}
//#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _menuItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType == LEFTMENUCELL_USERINFOR) {
        return 70;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2 || section == 5) {
        UIView *uivie = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        //uivie.backgroundColor = [UIColor colorWithARGBHex:HC_Gray_Line];
        uivie.backgroundColor = [UIColor grayColor];
        uivie.alpha = 0.38;
        return uivie;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 头像信息
    if (((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType == LEFTMENUCELL_USERINFOR) {
        LeftMenuViewHeaderinfoCell *cell = [[LeftMenuViewHeaderinfoCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"headercell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.leftMenuCellItem = _menuItemArray[indexPath.section];
        return cell;
    }
    // 设置
    else if(((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType == LEFTMENUCELL_USERTYPE)
    {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xcell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"xcell"];
            }
            cell.imageView.image = [UIImage imageNamed:((LeftMenuCellItem *)_menuItemArray[indexPath.section]).iconName];
            cell.textLabel.text = ((LeftMenuCellItem *)_menuItemArray[indexPath.section]).titleLabelText;
            cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
            UIButton *switchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:switchbutton];
            [switchbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell).offset(-10);
                make.width.mas_equalTo(52);
                make.centerY.equalTo(cell.contentView);
                make.height.mas_equalTo(26);
            }];
            [switchbutton addTarget:self action:@selector(SettingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            switchbutton.tag = indexPath.row;
            if (GetUserType == 1) {
                [switchbutton setBackgroundImage:[UIImage imageNamed:@"open_person"] forState:UIControlStateNormal];
            }
            else {
                [switchbutton setBackgroundImage:[UIImage imageNamed:@"open_company"] forState:UIControlStateNormal];
            }
            return cell;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:((LeftMenuCellItem *)_menuItemArray[indexPath.section]).iconName];
    cell.textLabel.text = ((LeftMenuCellItem *)_menuItemArray[indexPath.section]).titleLabelText;
    cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    cell.detailTextLabel.text = ((LeftMenuCellItem *)_menuItemArray[indexPath.section]).detialLabelText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if ([_delegate respondsToSelector:@selector(leftMenuViewOfTableviewDidSelectItemWithType:)] && _delegate) {
            [_delegate leftMenuViewOfTableviewDidSelectItemWithType:((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType];
        }
    }
}

//  设置中的按钮开关
- (void)SettingBtnClicked:(UIButton *)sender
{
    if(sender.tag == 0){
        if ([gCompanyInfo.cUnitCode isEqualToString:@""] || gCompanyInfo.cUnitCode == nil) {
            return;
        }

        if (GetUserType == 1) {
            [sender setBackgroundImage:[UIImage imageNamed:@"open_company"] forState:UIControlStateNormal];
            SetUserType(2);
        }
        else{
            [sender setBackgroundImage:[UIImage imageNamed:@"open_person"] forState:UIControlStateNormal];
            SetUserType(1);
        }
        [self initData];
        [_tableView reloadData];

        if ([_delegate respondsToSelector:@selector(leftMenuViewIsChangedUserType)] && _delegate) {
            [_delegate leftMenuViewIsChangedUserType];
        }
    }
}
@end
