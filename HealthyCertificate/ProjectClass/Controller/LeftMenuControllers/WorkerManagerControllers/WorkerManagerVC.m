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
#import "HttpNetworkManager.h"
#import "Constants.h"
#import "Customer.h"
#import "RzAlertView.h"
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface WorkerManagerVC ()<UITableViewDelegate, UITableViewDataSource, AddworkVControllerDelegate>
{
    UITableView *_tableView;
    UIBarButtonItem *_rightBarItem;    // 显示员工数量
    UIButton    *_addNewWorkBtn;     // 增加员工按钮

    NSMutableArray *_worksData;     // 原始数据

    NSMutableArray *_worksArray;    // 模型数组

    RzAlertView *_waitAlertView;
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60) style:UITableViewStylePlain];
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
    [[HttpNetworkManager getInstance] getWorkerCustomerDataWithcUnitCode:gCompanyInfo.cUnitCode resultBlock:^(NSArray *result, NSError *error) {
        if (!error) {
            _worksData = [NSMutableArray arrayWithArray:result];
            _worksArray = [[NSMutableArray alloc]init];
            for (Customer *custom in _worksData) {
                NSString *sex = custom.sex == 0 ? @"男" : @"女";
                WorkManagerTBCItem *item = [[WorkManagerTBCItem alloc]initWithName:custom.custName sex:sex tel:custom.linkPhone Type:0];
                [_worksArray addObject:item];
            }
            [self setworkCount];
            [_tableView reloadData];
        }
        else{
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"网络出现问题，请重试" removeDelay:2];
        }
    }];
}
// 设置员工人数
- (void)setworkCount
{
    [_rightBarItem setTitle:[NSString stringWithFormat:@"员工人数 %lu", (unsigned long)_worksArray.count]];
}
// 新增员工按钮点击事件
- (void)addWorkBtnClicked:(UIButton *)sender
{
    AddWorkerVController *add = [[AddWorkerVController alloc]init];
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];
}
#pragma mark - 添加员工成功的delegate
- (void)creatWorkerSucceed
{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"添加成功" removeDelay:2];
    [self getdata];
}

#pragma mark - tableview delegate datasource
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
    return 10+44+10+44+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section != 0){
        return nil;
    }
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footview"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"footview"];
        view.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
        view.textLabel.textColor = [UIColor grayColor];
    }
    view.textLabel.text = @"向左滑动可删除员工";
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0){
        return nil;
    }
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerview"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerview"];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(-2, 10, self.view.frame.size.width + 4, 44)];
        [view addSubview:nameLabel];
        nameLabel.backgroundColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"知康科技有限公司";

        WorkManagerTBC *cell = [[WorkManagerTBC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
        [view addSubview:cell];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setCellItem:[[WorkManagerTBCItem alloc]initWithName:@"姓名" sex:@"性别" tel:@"电话" Type:0]];
        cell.sexLabel.textColor = [UIColor blackColor];
        cell.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    }
    return view;
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
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_waitAlertView) {
        _waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@"请稍侯..."];
    }
    [_waitAlertView show];

    [[HttpNetworkManager getInstance] removeCustomerWithCustomer:_worksData[indexPath.row] resultBlock:^(MethodResult *result, NSError *error) {
        [_waitAlertView close];
        if (!error) {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"删除成功" removeDelay:2];
            [_worksArray removeObjectAtIndex:indexPath.row];
            [_worksData removeObjectAtIndex:indexPath.row];
            [self setworkCount];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else{
            if (result) {
                [RzAlertView showAlertLabelWithTarget:self.view Message:result.errorMsg removeDelay:2];
            }
            else{
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"删除失败，请检查网络后重试" removeDelay:2];
            }
        }
    }];

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
@end
