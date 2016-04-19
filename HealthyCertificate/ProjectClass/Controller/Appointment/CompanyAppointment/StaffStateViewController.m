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
#import "PayMoneyController.h"

@interface StaffStateViewController()<UITableViewDataSource, UITableViewDelegate, PCheckAllPayViewDelegate,PayMoneyDelegate>
{
    
    NSMutableArray      *_toPaySource;
    NSMutableArray      *_payedSource;
    
    NSMutableDictionary *_choosedDic;
    
    UITableView         *_tableView;
    UILabel             *_tipLabel;
    
    UIButton            *_updateBtn;
    UIButton            *_batchPayBtn;
    PCheckAllPayView    *_payCountView;
    
    float               _prize;
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
    _choosedDic = [[NSMutableDictionary alloc] init];
    
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

    _prize = 0;
    
    [self initNavgation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_toPaySource removeAllObjects];
    [_payedSource removeAllObjects];
    [_choosedDic removeAllObjects];
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
    
    _batchPayBtn = [UIButton buttonWithTitle:@"批量支付"
                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                   backgroundColor:[UIColor clearColor]];
    [_batchPayBtn addTarget:self action:@selector(batchPayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_batchPayBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
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
        
        [[HttpNetworkManager getInstance] getCustomerTestChargePriceWithCityName:_cityName checkType:nil resultBlcok:^(NSString *result, NSError *error) {
            if (error!=nil){
                return;
            }
            _prize = [result floatValue];
        }];
        
    }else{
        [sender setTitle:@"批量支付" forState:UIControlStateNormal];
        [_tableView setEditing:NO animated:YES];
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        
        [_choosedDic removeAllObjects];
        [_payCountView setMoney:0 count:0];
    }
}

#pragma mark - Private Methods
-(void)loadData
{
    [RzAlertView ShowWaitAlertWithTitle:@""];
    [[HttpNetworkManager getInstance] findCustomerTestByContract:_contractCode resultBlock:^(NSArray *result, NSError *error) {
        [RzAlertView CloseWaitAlert];
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
        _payCountView.allCount = _toPaySource.count;
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

-(void)updateBottomView
{
    if (_toPaySource.count == 0){
        return;
    }
    
    NSArray *indexArr = [_choosedDic allKeys];
    float money = 0;
    BOOL flag = YES;
    for (NSNumber *index in indexArr) {
        if (((CustomerTest *)_toPaySource[[index integerValue]]).needMoney <= 0) {
            flag = NO;
            NSString *message = [NSString stringWithFormat:@"没有获取到 %@ %@ 的体检单价\n请检查网络后重试", ((CustomerTest *)_toPaySource[[index integerValue]]).custName,
                                 ((CustomerTest *)_toPaySource[[index integerValue]]).cityName];
            [RzAlertView showAlertViewControllerWithViewController:self title:@"提示"
                                                           Message:message
                                                       ActionTitle:@"重试"
                                                       ActionStyle:UIAlertActionStyleDefault
                                                            handle:^(NSInteger flag) {
                [[HttpNetworkManager getInstance] getCustomerTestChargePriceWithCityName:((CustomerTest *)_toPaySource[[index integerValue]]).cityName
                                                                               checkType:nil
                                                                             resultBlcok:^(NSString *result, NSError *error) {
                    if (!error) {
                        ((CustomerTest *)_toPaySource[[index integerValue]]).needMoney = [result floatValue];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateBottomView];
                    });
                }];
            }];
        }
        else {
            money += ((CustomerTest *)_toPaySource[[index integerValue]]).needMoney;
        }
    }
    if (flag) {
        [_payCountView setMoney:money count:_choosedDic.count];
    }
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
    }else if (indexPath.section == 1){
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_payedSource.count != 0 && indexPath.section == 1){
        if (_tableView.editing){
            [_choosedDic removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
            [_payCountView setMoney:_prize * _choosedDic.count count:_choosedDic.count];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_toPaySource.count != 0 && indexPath.section == 1){
        if (_tableView.editing){
            if (_prize <= 0){
                [RzAlertView ShowWaitAlertWithTitle:@"获取应缴费用..."];
                [[HttpNetworkManager getInstance] getCustomerTestChargePriceWithCityName:_cityName checkType:nil resultBlcok:^(NSString *result, NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error!=nil){
                            [RzAlertView CloseWaitAlert];
                            [RzAlertView showAlertLabelWithMessage:@"获取应缴费用失败" removewDelay:2];
                            [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
                            return;
                        }
                        [RzAlertView CloseWaitAlert];
                        _prize = [result floatValue];
                        [_choosedDic setObject:[NSNumber numberWithInteger:indexPath.row] forKey:[NSNumber numberWithInteger:indexPath.row]];
                    });
                }];
            }else{
                [_choosedDic setObject:[NSNumber numberWithInteger:indexPath.row] forKey:[NSNumber numberWithInteger:indexPath.row]];
            }
        }
        [_payCountView setMoney:_prize * _choosedDic.count count:_choosedDic.count];
    }
}

#pragma mark - PayMoneyDelegate
/**
 *  支付成功
 */
- (void)payMoneySuccessed{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您的预约支付已完成" removeDelay:2];
}
/**
 *  支付取消
 */
- (void)payMoneyCencel{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"您取消了支付" removeDelay:2];
    [self batchPayBtnClicked:_batchPayBtn];
}
/**
 *  支付失败
 */
- (void)payMoneyFail{
    [RzAlertView showAlertLabelWithTarget:self.view Message:@"支付失败" removeDelay:2];
}

- (void)payMoneyByOthers
{
    
}

#pragma mark - PCheckAllPayViewDelegate
-(void)payAll{
    NSArray *index = [_choosedDic allKeys];
    NSMutableArray *customers = [[NSMutableArray alloc]init];
    for (NSNumber *i in index) {
        CustomerTest* customerTest = (CustomerTest *)_toPaySource[[i integerValue]];
        customerTest.needMoney = _prize;
        [customers addObject:customerTest];
    }
    if(customers.count == 0)
    {
        [RzAlertView showAlertLabelWithMessage:@"请选择支付对象" removewDelay:2];
        return;
    }
    PayMoneyController *pay = [[PayMoneyController alloc]init];
    pay.chargetype = BatchCharge;
    pay.delegate = self;
    pay.CustomerTestArray = customers;
    [self.navigationController pushViewController:pay animated:YES];
    
}

-(void)selectAll{
    if (_prize <= 0){
        [RzAlertView ShowWaitAlertWithTitle:@"获取应缴费用..."];
        [[HttpNetworkManager getInstance] getCustomerTestChargePriceWithCityName:_cityName checkType:nil resultBlcok:^(NSString *result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error!=nil){
                    [RzAlertView CloseWaitAlert];
                    [RzAlertView showAlertLabelWithMessage:@"获取应缴费用失败" removewDelay:2];
                    return;
                }
                [RzAlertView CloseWaitAlert];
                _prize = [result floatValue];
                [self SelectAllCustomer];
            });
        }];
    }else{
        [self SelectAllCustomer];
    }
}

-(void)deSelectAll{
    [_choosedDic removeAllObjects];
    [_tableView reloadData];
    [_payCountView setMoney:0 count:0];
}

#pragma mark - Private Methods
-(void)SelectAllCustomer
{
    [_choosedDic removeAllObjects];
    
    for (int i = 0; i < _toPaySource.count; ++i){
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:1];
        [_tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [_choosedDic setObject:[NSNumber numberWithInteger:indexpath.row] forKey:[NSNumber numberWithInteger:indexpath.row]];
    }
    [_payCountView setMoney:_prize * _choosedDic.count count:_choosedDic.count];
}

@end
