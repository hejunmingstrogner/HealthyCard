//
//  WorkTypeViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/1.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "WorkTypeViewController.h"
#import <Masonry.h>

#import "WorkTypeInfoModel.h"
#import "HttpNetworkManager.h"

@interface WorkTypeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray         *_dataSource;
    UITableView     *_industryTableView;
}

@end

@implementation WorkTypeViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _industryTableView = [[UITableView alloc] init];
    _industryTableView.dataSource = self;
    _industryTableView.delegate = self;
    [_industryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:_industryTableView];
    [_industryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    [self initNavgationBar];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods
-(void)loadData
{
    [[HttpNetworkManager getInstance] getIndustryList:@"健康证行业" resultBlock:^(NSArray *result, NSError *error) {
        _dataSource = result;
        [_industryTableView reloadData];
    }];
}

-(void)initNavgationBar{
    // 返回按钮
    self.title = @"行业选择";
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    //backbtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
}

#pragma mark - Action
-(void)backToPre:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    WorkTypeInfoModel* workInfoModel = (WorkTypeInfoModel*)_dataSource[indexPath.row];
    cell.textLabel.text = workInfoModel.name;
    if ( [cell respondsToSelector:@selector(setSeparatorInset:)] )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ( [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)] )
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ( [cell respondsToSelector:@selector(setLayoutMargins:)] )
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkTypeInfoModel* workInfoModel = (WorkTypeInfoModel*)_dataSource[indexPath.row];
    _block(workInfoModel.name);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
