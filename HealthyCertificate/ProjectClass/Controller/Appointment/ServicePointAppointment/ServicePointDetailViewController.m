//
//  ServicePointDetailViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServicePointDetailViewController.h"
#import "ServicePositionCarHeadTableViewCell.h"
#import <Masonry.h>

@implementation ServicePointDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initData];

    [self initSubViews];
}

- (void)initNavgation
{
    self.title = _serverPositionItem.name;  // 车辆牌照
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{

}

- (void)initSubViews
{
    _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_orderBtn];
    [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    _orderBtn.layer.masksToBounds = YES;
    _orderBtn.layer.cornerRadius = 5;
    _orderBtn.layer.borderColor = [UIColor colorWithRed:50/255.0 green:170/255.0 blue:240/255.0 alpha:1].CGColor;
    [_orderBtn setTitle:@"预约" forState:UIControlStateNormal];
    [_orderBtn setTitleColor:[UIColor colorWithRed:50/255.0 green:170/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_orderBtn.mas_top).offset(-10);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    UILabel *fenge = [[UILabel alloc]init];
    [self.view addSubview:fenge];
    [fenge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    fenge.layer.borderColor = [UIColor lightGrayColor].CGColor;
    fenge.layer.borderWidth = 1;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }
    else if (indexPath.row == 1){
        if (indexPath.section == 1) {
            return fmaxf(44, [self cellheight:_serverPositionItem.introduce]);
        }
        return fmaxf(44, [self cellheight:_serverPositionItem.busWay]);
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ServicePositionCarHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        if (!cell) {
            cell = [[ServicePositionCarHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carcell"];
        }
        [cell setCellItem:_serverPositionItem];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.numberOfLines = 0;
        }
        if (indexPath.row == 0) {
            if(indexPath.section == 1){
                cell.textLabel.text = @"详细介绍";
            }
            else {
                cell.textLabel.text = @"路线地址";
            }

        }
        else {
            if(indexPath.section == 1){
                cell.textLabel.text = _serverPositionItem.introduce;
            }
            else {
                cell.textLabel.text = _serverPositionItem.busWay;
            }

        }
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else{
            cell.textLabel.textColor = [UIColor grayColor];
        }

        return cell;
    }
}

- (CGFloat)cellheight:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:17];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+10;
    return he;
}

- (void)orderBtnClicked:(UIButton *)sender
{
    NSLog(@"预约");
}
@end
