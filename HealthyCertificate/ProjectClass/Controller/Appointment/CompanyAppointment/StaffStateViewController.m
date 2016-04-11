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

#import "ExamItemStateCell.h"
#import "PCheckAllPayView.h"

@interface StaffStateViewController()<UITableViewDataSource, UITableViewDelegate, PCheckAllPayViewDelegate>
{
    
    NSMutableArray      *_toPaySource;
    NSMutableArray      *_payedSource;
    
    NSMutableArray      *_choosedArr;
    
    UITableView         *_tableView;
    UILabel             *_tipLabel;
    RzAlertView         *_loadingView;
    
    UIButton            *_updateBtn;
    PCheckAllPayView    *_payCountView;
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
    
    _toPaySource = [[NSMutableArray alloc] init];
    _payedSource = [[NSMutableArray alloc] init];
    _choosedArr = [[NSMutableArray alloc] init];
    
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
    
    _payCountView = [[PCheckAllPayView alloc] init];
    _payCountView.delegate = self;
    [self.view addSubview:_payCountView];
    [_payCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@60);
    }];
    
    
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
    
//    UIButton* batchPayBtn = [UIButton buttonWithTitle:@"批量支付"
//                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
//                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
//                                   backgroundColor:[UIColor clearColor]];
//    [batchPayBtn addTarget:self action:@selector(batchPayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:batchPayBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
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

-(void)batchPayBtnClicked:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"批量支付"]){
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        [_tableView setEditing:YES animated:YES];
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-61);
        }];
        
        [_choosedArr removeAllObjects];
        for (NSInteger index = 0; index < _toPaySource.count; index++) {
            [_choosedArr addObject:_toPaySource[index]];
        }
        
    }else{
        [sender setTitle:@"批量支付" forState:UIControlStateNormal];
        [_tableView setEditing:NO animated:YES];
        [_choosedArr removeAllObjects];
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    }
}


#pragma mark - Private Methods
-(void)loadData
{
    [_loadingView show];
    [[HttpNetworkManager getInstance] getCustomerTestListByContract:_contractCode resultBlock:^(NSArray *result, NSError *error) {
        [_loadingView close];
        if (error != nil){
            return;
        }
        for (NSInteger index = 0; index < result.count; ++index){
            CustomerTest* customerTest = (CustomerTest*)result[index];
            if (customerTest.payMoney <= 0){
                [_toPaySource addObject:customerTest];
            }else{
                [_payedSource addObject:customerTest];
            }
        }
        if (_toPaySource.count + _payedSource.count == 0){
            _updateBtn.hidden = NO;
            _tableView.hidden = YES;
        }else{
            _updateBtn.hidden = YES;
            _tableView.hidden = NO;
        }
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else if (section == 1){
        return _toPaySource.count != 0 ? _toPaySource.count : _payedSource.count;
    }else{
        return _payedSource.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(100);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _payedSource.count != 0 && _payedSource.count != 0 ? 3 : 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExamItemStateCell* cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ExamItemStateCell class])];
    if (cell == nil){
        cell = [[ExamItemStateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([ExamItemStateCell class])];
    }
    
    if (indexPath.section == 0){
        cell.customerTest = nil;
    }else if (indexPath.section == 1){
        cell.customerTest = _toPaySource.count != 0 ? (CustomerTest*)_toPaySource[indexPath.row] : (CustomerTest*)_payedSource[indexPath.row];
    }else{
        cell.customerTest = (CustomerTest*)_payedSource[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PXFIT_HEIGHT(20);
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_toPaySource.count == 0){
        return UITableViewCellEditingStyleNone;
    }
    
    if (indexPath.section == 0){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

@end
