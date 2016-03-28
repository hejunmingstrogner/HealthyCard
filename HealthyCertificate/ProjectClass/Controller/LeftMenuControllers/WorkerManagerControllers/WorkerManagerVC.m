//
//  WorkerManagerVC.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "WorkerManagerVC.h"

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"
#import <Masonry.h>
#import "WorkManagerTBC.h"
#import "AddWorkerVController.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface WorkerManagerVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    UIBarButtonItem *_rightBarItem;    // 显示员工数量
    UIButton    *_addNewWorkBtn;     // 增加员工按钮

    NSMutableArray *_worksData;     // 原始数据

    NSMutableArray *_worksArray;    // 模型数组
}

@end

@implementation WorkerManagerVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubviews];

    [self getdata];
}

- (void)initNavgation
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"员工管理";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;

    _rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"员工人数" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = _rightBarItem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubviews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setEditing:NO animated:YES];

    _addNewWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_addNewWorkBtn];
    _addNewWorkBtn.layer.masksToBounds = YES;
    _addNewWorkBtn.layer.cornerRadius = 4;
    [_addNewWorkBtn setTitle:@"新增员工" forState:UIControlStateNormal];
    [_addNewWorkBtn setBackgroundColor:[UIColor colorWithRed:44/255.0 green:148/255.0 blue:232/255.0 alpha:1]];
    [_addNewWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    [_addNewWorkBtn addTarget:self action:@selector(addWorkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getdata
{
    WorkManagerTBCItem *item = [[WorkManagerTBCItem alloc]initWithName:@"张山" sex:@"男" tel:@"18380447477" Type:0];
    _worksArray = [NSMutableArray arrayWithObjects:item, item, item, item, nil];
    [_tableView reloadData];
}

// 新增员工按钮点击事件
- (void)addWorkBtnClicked:(UIButton *)sender
{
    AddWorkerVController *add = [[AddWorkerVController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _worksArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10+44+10+44+10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"向左滑动可删除员工";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0){
        return nil;
    }
    UIView *_uiview = [[UIView alloc]init];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(-2, 10, self.view.frame.size.width + 4, 44)];
    [_uiview addSubview:nameLabel];
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"知康科技有限公司";

    WorkManagerTBC *cell = [[WorkManagerTBC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
    [_uiview addSubview:cell];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setCellItem:[[WorkManagerTBCItem alloc]initWithName:@"姓名" sex:@"性别" tel:@"电话" Type:0]];
    cell.sexLabel.textColor = [UIColor blackColor];
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(nameLabel);
        make.height.mas_equalTo(44);
    }];
    return _uiview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkManagerTBC *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[WorkManagerTBC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setCellItem:(WorkManagerTBCItem*)_worksArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WorkManagerTBC *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.editing = YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_worksArray removeObjectAtIndex:indexPath.row];
    [_worksData removeObjectAtIndex:indexPath.row];

    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
@end
