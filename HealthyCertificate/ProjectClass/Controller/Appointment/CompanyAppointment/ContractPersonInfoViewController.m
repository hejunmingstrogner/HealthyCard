//
//  ContractPersonInfoViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ContractPersonInfoViewController.h"

#import <Masonry.h>

#import "UIButton+HitTest.h"
#import "UIButton+Easy.h"

#import "HttpNetworkManager.h"

#import "CustomerTestTableViewCell.h"
#import "PersonalHealthyCController.h"

#import "CustomerTest.h"



@interface ContractPersonInfoViewController()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray*        _dataSourceArr;
    
    UITableView*    _tableView;
}
@end


@implementation ContractPersonInfoViewController

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#pragma mark - Life Circle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[CustomerTestTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CustomerTestTableViewCell class])];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    [self loadData];
}

- (void)initNavgation
{
    self.title = @"我的预约";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
}


#pragma mark - Action
-(void)backToPre:(UIButton*) sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Private Methods
-(void)loadData
{
    [[HttpNetworkManager getInstance] findCustomerTestByContract:_brContract.code resultBlock:^(NSArray *result, NSError *error) {
        _dataSourceArr = result;
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerTestTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomerTestTableViewCell class])];
    [cell setCellItemWithTest:_dataSourceArr[indexPath.section]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalHealthyCController* personalHealthyVC = [[PersonalHealthyCController alloc] init];
    personalHealthyVC.isHistorySave = YES;
    personalHealthyVC.customerTestInfo = _dataSourceArr[indexPath.section];
    [self.navigationController pushViewController:personalHealthyVC animated:YES];
}



@end
