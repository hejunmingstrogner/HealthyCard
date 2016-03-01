//
//  WaitDocResultSelectViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "WaitDocResultSelectViewController.h"
#import "WaitDocResultTableViewCell.h"

@implementation WaitDocResultSelectViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initData];

    [self initSubViews];
}


- (void)initNavgation
{
    self.title = @"候诊查询";
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
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
    WaitDocResultSelectItem *item1 = [[WaitDocResultSelectItem alloc]initWithProjectDetail:@"项目明细" countAndTime:@"人数／时间" status:@"状态"];
    WaitDocResultSelectItem *item2 = [[WaitDocResultSelectItem alloc]initWithProjectDetail:@"胸透" countAndTime:@"3人/10分钟" status:@"已检"];
    WaitDocResultSelectItem *item3 = [[WaitDocResultSelectItem alloc]initWithProjectDetail:@"项目明细" countAndTime:@"5人／10分钟" status:@"排队"];
    WaitDocResultSelectItem *item4 = [[WaitDocResultSelectItem alloc]initWithProjectDetail:@"项目明细" countAndTime:@"" status:@"已检"];

    _waitDocResultArray = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, nil];
}

- (void)initSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _waitDocResultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaitDocResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WaitDocResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setCellItem:_waitDocResultArray[indexPath.row]];
    return cell;
}

@end
