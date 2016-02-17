//
//  LeftMenuView.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "LeftMenuView.h"

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
    _tableView = [[UITableView alloc]initWithFrame:self.frame];
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)initData
{
    LeftMenuCellItem *userinformation = [[LeftMenuCellItem alloc]initWithiconName:@"headimage" titleLabelText:@"张三" detialLabelText:@"18380446542" itemtype:LEFTMENUCELL_USERINFOR];
    LeftMenuCellItem *historyRecord = [[LeftMenuCellItem alloc]initWithiconName:@"historyRecord" titleLabelText:@"历史记录" detialLabelText:nil itemtype:LEFTMENUCELL_HISTORYRECORD];
    LeftMenuCellItem *setting = [[LeftMenuCellItem alloc]initWithiconName:@"setting" titleLabelText:@"设置" detialLabelText:nil itemtype:LEFTMENUCELL_SETTING];
    LeftMenuCellItem *notice = [[LeftMenuCellItem alloc]initWithiconName:@"notice" titleLabelText:@"体检注意事项" detialLabelText:nil itemtype:LEFTMENUCELL_NOTICE];
    LeftMenuCellItem *uintlogin = [[LeftMenuCellItem alloc]initWithiconName:@"uintlogin" titleLabelText:@"单位注册" detialLabelText:nil itemtype:LEFTMENUCELL_LOGIN];
    LeftMenuCellItem *aboutUs = [[LeftMenuCellItem alloc]initWithiconName:@"aboutUs" titleLabelText:@"关于我们" detialLabelText:nil itemtype:LEFTMENUCELL_ABOUTUS];
    LeftMenuCellItem *advice = [[LeftMenuCellItem alloc]initWithiconName:@"advice" titleLabelText:@"意见或建议" detialLabelText:nil itemtype:LEFTMENUCELL_ADVICE];
    LeftMenuCellItem *exit = [[LeftMenuCellItem alloc]initWithiconName:@"exit" titleLabelText:@"退出当前账号" detialLabelText:nil itemtype:LEFTMENUCELL_EXIT];

    _menuItemArray = [NSMutableArray arrayWithObjects:userinformation, historyRecord, setting, notice, uintlogin, aboutUs, advice, exit, nil];

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
        return 70;
    }
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
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"headercell"];
        }
        cell.imageView.image = [UIImage imageNamed:((LeftMenuCellItem *)_menuItemArray[indexPath.section]).iconName];
        cell.textLabel.text = ((LeftMenuCellItem *)_menuItemArray[indexPath.section]).titleLabelText;
        cell.detailTextLabel.text = ((LeftMenuCellItem *)_menuItemArray[indexPath.section]).detialLabelText;
        return cell;
    }
    // 设置
    else if(((LeftMenuCellItem *)_menuItemArray[indexPath.section]).itemType == LEFTMENUCELL_SETTING)
    {
        if (indexPath.row != 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setcell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setcell"];
                cell.imageView.image = [UIImage imageNamed:@"kongbai"];
            }
            cell.textLabel.text = _settingItemArray[indexPath.row];
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
@end
