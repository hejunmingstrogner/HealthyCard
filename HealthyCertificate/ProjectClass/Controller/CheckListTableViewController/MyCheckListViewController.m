//
//  MyCheckListViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "MyCheckListViewController.h"
#import "Constants.h"
#import "CustomerTestTableViewCell.h"
#import "BRContract.h"
#import "BRContractTableHeaerCell.h"
#import "BRContractTableFootCell.h"

@interface MyCheckListViewController()
{
    NSMutableArray *checkDataArray;
}

@end

@implementation MyCheckListViewController

@synthesize checkDataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];
}


- (void)initNavgation
{
    self.title = @"我的预约";
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


- (void)initSubViews
{
    _userType = GetUserType;

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return checkDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_userType == 1) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_userType == 1){
        return 110;
    }
    else {
        if (indexPath.row == 0) {
            return 80;
        }
        else
        {
            return 40;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 个人
    if (_userType == 1) {
        CustomerTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CustomerTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell setCellItemWithTest:(CustomerTest *)checkDataArray[indexPath.section]];
        return cell;
    }
    // 单位
    else{
        if (indexPath.row == 0) {
            BRContractTableHeaerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellheader"];
            if (!cell) {
                cell = [[BRContractTableHeaerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellheader"];
            }
            [cell setCellItem:(BRContract *)checkDataArray[indexPath.section]];
            return cell;
        }
        else {
            BRContractTableFootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellfoot"];
            if (!cell ) {
                cell = [[BRContractTableFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellfoot"];
            }
            [cell setCellItem:(BRContract *)checkDataArray[indexPath.section]];
            return cell;
        }
    }
}

@end
