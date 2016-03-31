//
//  RegisterViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/31.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "RegisterViewController.h"

#import "UnitRegisterTitleView.h"
#import "UnitRegisterItemCell.h"

#import "UIColor+Expanded.h"
#import "UIButton+Easy.h"
#import "UIFont+Custom.h"

#import "HCBackgroundColorButton.h"

#import "Constants.h"

#import <Masonry.h>

@interface RegisterViewController()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation RegisterViewController
{
    UITableView         *_tableView;
    
    NSArray             *_dataSource;
}


#pragma mark - UIViewController overrides
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIView* containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UnitRegisterTitleView* titleView = [[UnitRegisterTitleView alloc] init];
    [containerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView);
        make.height.mas_equalTo(40);
        make.left.equalTo(containerView).with.offset(15);
        make.right.equalTo(containerView).with.offset(-15);
    }];
    
    _tableView = [[UITableView alloc] init];
    [containerView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).with.offset(10);
        make.right.equalTo(containerView).with.offset(-10);
        make.top.equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(6*PXFIT_HEIGHT(100));
    }];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UnitRegisterItemCell class] forCellReuseIdentifier:NSStringFromClass([UnitRegisterItemCell class])];
    
//    UIView* bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    [containerView addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(containerView);
//        make.top.mas_equalTo(_tableView.mas_bottom);
//        make.height.mas_equalTo(PXFIT_HEIGHT(136));
//    }];
//    
//    HCBackgroundColorButton* regBtn = [[HCBackgroundColorButton alloc] init];
//    [regBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
//    [regBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
//    [regBtn setTitle:@"预   约" forState:UIControlStateNormal];
//    [regBtn addTarget:self action:@selector(appointmentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    regBtn.layer.cornerRadius = 5;
//    [bottomView addSubview:regBtn];
//    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(bottomView);
//        make.left.mas_equalTo(bottomView).with.offset(PXFIT_WIDTH(24));
//        make.right.mas_equalTo(bottomView).with.offset(-PXFIT_WIDTH(24));
//        make.top.mas_equalTo(bottomView).with.offset(PXFIT_HEIGHT(20));
//        make.bottom.mas_equalTo(bottomView).with.offset(-PXFIT_HEIGHT(20));
//    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tableView.mas_bottom);
    }];

    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerKeyboardNotification];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self cancelKeyboardNotification];
}




#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitRegisterItemCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UnitRegisterItemCell class])];
    cell.titleText = _dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXFIT_HEIGHT(100);
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Private Methods
-(void)loadData
{
    _dataSource = @[@"*单位名称", @"*负责人 ", @"*手机号 ", @"*行业  ", @" 员工人数", @"*单位地址"];
}

-(void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}

-(void)cancelKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
       [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self.view.mas_bottom).with.offset(-keyboardBounds.size.height);
       }];
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
       [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self.view);
       }];
    } completion:NULL];
}


@end
