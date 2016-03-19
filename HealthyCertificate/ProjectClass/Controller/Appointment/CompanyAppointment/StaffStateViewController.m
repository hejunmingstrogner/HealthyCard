//
//  StaffStateViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "StaffStateViewController.h"

#import <Masonry.h>

#import "Constants.h"

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIColor+Expanded.h"
#import "UILabel+Easy.h"

#import "HttpNetworkManager.h"
#import "RzAlertView.h"

#import "CustomerTest.h"

@interface StaffStateViewController()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray             *_dataSource;
    UITableView         *_tableView;
    UILabel             *_tipLabel;
    RzAlertView         *_loadingView;
    
    UIButton            *_updateBtn;
}

@end


@implementation StaffStateViewController

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

#define Cell_Font 23

#pragma mark - Life Circle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
    _dataSource = [[NSArray alloc] init];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _updateBtn = [UIButton buttonWithTitle:@"点击刷新"
                                               font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(26)]
                                          textColor:[UIColor colorWithRGBHex:HC_Gray_Text]
                                    backgroundColor:nil];
    [_updateBtn addTarget:self action:@selector(updateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_updateBtn];
    [_updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    _updateBtn.hidden = YES;
    
    _loadingView = [[RzAlertView alloc] initWithSuperView:self.view Title:@" "];
    [self initNavgation];
    
    [self loadData];
}

- (void)initNavgation
{
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"员工状态";
}

#pragma mark - Action
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateBtnClicked:(UIButton*)sender
{
    _updateBtn.hidden = YES;
    [self loadData];
}


#pragma mark - Private Methods
-(void)loadData
{
    [_loadingView show];
    __typeof (self) __weak weakSelf = self;
    [[HttpNetworkManager getInstance] getCustomerTestListByContract:_contractCode resultBlock:^(NSArray *result, NSError *error) {
        __typeof (self)  strongSelf = weakSelf; //防止循环引用
        [strongSelf->_loadingView close];
        if (error != nil){
            return;
        }
        strongSelf->_dataSource = result;
        
        if (strongSelf->_dataSource.count == 0){
            strongSelf->_updateBtn.hidden = NO;
            strongSelf->_tableView.hidden = YES;
        }else{
            strongSelf->_updateBtn.hidden = YES;
            strongSelf->_tableView.hidden = NO;
        }
        [strongSelf->_tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(100);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StaffStateViewController class])];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([StaffStateViewController class])];
    }
    cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    
    CustomerTest* customerTest = (CustomerTest*)_dataSource[indexPath.row];
    int status = [customerTest.testStatus intValue];
    if (status == 5 || status == 6){
        //未检
        cell.detailTextLabel.text = @"未检";
        cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Orange_Text];
    }
    
    if (status <= -1){
        //未检
        cell.detailTextLabel.text = @"未检";
         cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Orange_Text];
        
    }else if (status < 3){
        //在检
        cell.detailTextLabel.text = @"在检";
         cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:HC_Base_Green];
    }else{
        //已检
        cell.detailTextLabel.text = @"已检";
         cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    }
    
    cell.textLabel.text = customerTest.custName;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PXFIT_HEIGHT(20);
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
}

@end
