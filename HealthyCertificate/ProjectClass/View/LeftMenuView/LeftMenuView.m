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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height)];
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)initData
{
    // 个人
    LeftMenuCellItem *userinformation;
    if (GetUserType == 1) {
        userinformation = [[LeftMenuCellItem alloc]initWithiconName:@"headimage" titleLabelText:gPersonInfo.mCustName detialLabelText:gPersonInfo.StrTel itemtype:LEFTMENUCELL_USERINFOR];
    }
    else if(GetUserType == 2)
    {
         userinformation = [[LeftMenuCellItem alloc]initWithiconName:@"headimage" titleLabelText:gCompanyInfo.cUnitName detialLabelText:gPersonInfo.StrTel itemtype:LEFTMENUCELL_USERINFOR];
    }
    LeftMenuCellItem *historyRecord = [[LeftMenuCellItem alloc]initWithiconName:@"historyRecord" titleLabelText:@"历史记录" detialLabelText:nil itemtype:LEFTMENUCELL_HISTORYRECORD];
    LeftMenuCellItem *setting = [[LeftMenuCellItem alloc]initWithiconName:@"setting" titleLabelText:@"设置" detialLabelText:nil itemtype:LEFTMENUCELL_SETTING];
    LeftMenuCellItem *notice = [[LeftMenuCellItem alloc]initWithiconName:@"notice" titleLabelText:@"体检注意事项" detialLabelText:nil itemtype:LEFTMENUCELL_NOTICE];
    //LeftMenuCellItem *share = [[LeftMenuCellItem alloc]initWithiconName:@"share" titleLabelText:@"分享" detialLabelText:nil itemtype:LEFTMENUCELL_SHARE];
    //LeftMenuCellItem *uintlogin = [[LeftMenuCellItem alloc]initWithiconName:@"danweilogin" titleLabelText:@"单位注册" detialLabelText:nil itemtype:LEFTMENUCELL_LOGIN];
    LeftMenuCellItem *aboutUs = [[LeftMenuCellItem alloc]initWithiconName:@"aboutUs" titleLabelText:@"关于我们" detialLabelText:nil itemtype:LEFTMENUCELL_ABOUTUS];
    LeftMenuCellItem *advice = [[LeftMenuCellItem alloc]initWithiconName:@"advice" titleLabelText:@"意见或建议" detialLabelText:nil itemtype:LEFTMENUCELL_ADVICE];
    LeftMenuCellItem *exit = [[LeftMenuCellItem alloc]initWithiconName:@"exit" titleLabelText:@"退出当前账号" detialLabelText:nil itemtype:LEFTMENUCELL_EXIT];

    _menuItemArray = [NSMutableArray arrayWithObjects:userinformation, historyRecord, setting, notice, aboutUs, advice, exit, nil];

    _settingItemArray = [NSMutableArray arrayWithObjects:@"设置", @"提醒", @"用户类型", @"版本更新", nil];
}
//#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _menuItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((LeftMenuCellItem *)_menuItemArray[section]).itemType == LEFTMENUCELL_SETTING) {
        return _settingItemArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType == LEFTMENUCELL_USERINFOR) {
        //return PXFIT_HEIGHT(168);
        return 70;
    }
    if (((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType == LEFTMENUCELL_SETTING) {
        if (indexPath.row != 0) {
            //return PXFIT_HEIGHT(84);
            return 40;
        }
    }
    //return PXFIT_HEIGHT(96);
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 头像信息
    if (((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType == LEFTMENUCELL_USERINFOR) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headercell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"headercell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@customer/getPhoto?cCustCode=%@", [HttpNetworkManager baseURL], gPersonInfo.mCustCode]] placeholderImage:[UIImage imageNamed:((LeftMenuCellItem *)_menuItemArray[indexPath.section]).iconName] options:SDWebImageRefreshCached];
        cell.textLabel.text = ((LeftMenuCellItem *)_menuItemArray[indexPath.section]).titleLabelText;
        cell.detailTextLabel.text = ((LeftMenuCellItem *)_menuItemArray[indexPath.section]).detialLabelText;
        return cell;
    }
    // 设置
    else if(((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType == LEFTMENUCELL_SETTING)
    {
        if (indexPath.row != 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"xcell"];
            cell.imageView.image = [UIImage imageNamed:@"kongbai"];
            if (indexPath.row != 3) {
                UIButton *switchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell.contentView addSubview:switchbutton];
                [switchbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView).offset(5);
                    make.bottom.equalTo(cell.contentView).offset(-5);
                    make.right.equalTo(cell).offset(0);
                    make.width.mas_equalTo(60);
                }];
                [switchbutton addTarget:self action:@selector(SettingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                switchbutton.tag = indexPath.row;
                if (indexPath.row == 1) {
                    [switchbutton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
                }
                else {
                    if (GetUserType == 1) {
                        [switchbutton setImage:[UIImage imageNamed:@"open_person"] forState:UIControlStateNormal];
                    }
                    else {
                        [switchbutton setImage:[UIImage imageNamed:@"open_company"] forState:UIControlStateNormal];
                    }
                }
            }
            cell.textLabel.text = _settingItemArray[indexPath.row];
            if (indexPath.row == 3) {
                cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
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
    cell.detailTextLabel.text = ((LeftMenuCellItem *)_menuItemArray[indexPath.section]).detialLabelText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([_delegate respondsToSelector:@selector(leftMenuViewOfTableviewDidSelectItemWithType:)] && _delegate) {
            [_delegate leftMenuViewOfTableviewDidSelectItemWithType:((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType];
        }
    }
}

//  设置中的按钮开关
- (void)SettingBtnClicked:(UIButton *)sender
{
    if(sender.tag == 1)
    {

    }
    else if(sender.tag == 2){
        if (GetUserType == 1) {
            [sender setImage:[UIImage imageNamed:@"open_company"] forState:UIControlStateNormal];
            SetUserType(2);
        }
        else{
            [sender setImage:[UIImage imageNamed:@"open_person"] forState:UIControlStateNormal];
            SetUserType(1);
        }
        [self initData];
        [_tableView reloadData];
    }
}
@end
