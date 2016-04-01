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
#import "SelectAddressViewController.h"
#import "WorkTypeViewController.h"
#import "PostVeitifyViewController.h"

#import "UIColor+Expanded.h"
#import "UIButton+Easy.h"
#import "UIFont+Custom.h"
#import "UIButton+HitTest.h"
#import "NSString+Custom.h"

#import "HCBackgroundColorButton.h"

#import "Constants.h"
#import "RzAlertView.h"

#import <Masonry.h>

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface RegisterViewController()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate, UITextViewDelegate>
@end

@implementation RegisterViewController
{
    UITableView          *_tableView;
    NSArray              *_dataSource;
    
    //除键盘外的高度
    CGFloat               _viewHeight;
    
    //多行地址处理
    CGFloat               _cellHeight;
    
    //选择地址和行业
    NSString              *_address;
    NSString              *_workTypeStr;
    
    CLLocationCoordinate2D _locationCoordinate;
}

typedef NS_ENUM(NSInteger, TEXTVIEWTYPE)
{
    TextViewType_phoneNum = 1111,
    TextViewType_count
};


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
    titleView.title = @"单位信息";
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
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = [UIColor colorWithRGBHex:0xe8e8e8].CGColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[UnitRegisterItemCell class] forCellReuseIdentifier:NSStringFromClass([UnitRegisterItemCell class])];
    

    HCBackgroundColorButton* nextBtn = [[HCBackgroundColorButton alloc] init];
    [nextBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue_Pressed] forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 5;
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(_tableView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nextBtn.mas_bottom);
    }];

    
    [self loadData];
    
    [self initNavigation];
    
    //导航栏点击事件
    UITapGestureRecognizer* tapRecon = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(toggleMenu)];
    tapRecon.delegate = self;
    tapRecon.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:tapRecon];
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

-(void)initNavigation
{
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    self.title = @"单位注册";

}


#pragma mark - Action
-(void)nextBtnClicked:(UIButton*)sender
{
    //单位名称
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    UnitRegisterItemCell* unitCell = [_tableView cellForRowAtIndexPath:path];
    if (unitCell.textView.text == nil || [[unitCell.textView.text deleteSpaceWithHeadAndFootWithString] isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入单位名称" removeDelay:2];
        return;
    }
    
    //负责人
    path = [NSIndexPath indexPathForItem:1 inSection:0];
    UnitRegisterItemCell* chargePersonCell = [_tableView cellForRowAtIndexPath:path];
    if (chargePersonCell.textView.text == nil || [[chargePersonCell.textView.text deleteSpaceWithHeadAndFootWithString] isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入负责人" removeDelay:2];
        return;
    }
    
    //手机号
    path = [NSIndexPath indexPathForItem:2 inSection:0];
    UnitRegisterItemCell* phoneNumCell = [_tableView cellForRowAtIndexPath:path];
    if (phoneNumCell.textView.text == nil || [[phoneNumCell.textView.text deleteSpaceWithHeadAndFootWithString] isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入联系电话" removeDelay:2];
        return;
    }
    
    //行业
    path = [NSIndexPath indexPathForItem:3 inSection:0];
    UnitRegisterItemCell* industryCell = [_tableView cellForRowAtIndexPath:path];
    if (industryCell.textView.text == nil || [[industryCell.textView.text deleteSpaceWithHeadAndFootWithString] isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入行业信息" removeDelay:2];
        return;
    }
    
    //员工人数
    path = [NSIndexPath indexPathForItem:4 inSection:0];
    UnitRegisterItemCell* personCountCell = [_tableView cellForRowAtIndexPath:path];
    if (personCountCell.textView.text == nil || [[personCountCell.textView.text deleteSpaceWithHeadAndFootWithString] isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入员工人数" removeDelay:2];
        return;
    }
    
    //单位地址
    path = [NSIndexPath indexPathForItem:5 inSection:0];
    UnitRegisterItemCell* workAddrCell = [_tableView cellForRowAtIndexPath:path];
    if (workAddrCell.textView.text == nil || [[workAddrCell.textView.text deleteSpaceWithHeadAndFootWithString] isEqualToString:@""]){
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"请输入单位地址" removeDelay:2];
        return;
    }
    
    PostVeitifyViewController* postVC = [[PostVeitifyViewController alloc] init];
    
    BRServiceUnit* brServiceUnit = [[BRServiceUnit alloc] init];
    brServiceUnit.positionLO = _locationCoordinate.longitude;
    brServiceUnit.positonLA = _locationCoordinate.latitude;
    brServiceUnit.unitName = unitCell.textView.text;
    brServiceUnit.linkPeople = chargePersonCell.textView.text;
    brServiceUnit.linkPhone = phoneNumCell.textView.text;
    brServiceUnit.unitType = industryCell.textView.text;
    brServiceUnit.addr = workAddrCell.textView.text;
    
    postVC.brServiceUnit = brServiceUnit;
    
    [self.navigationController pushViewController:postVC animated:YES];
}

-(void)backToPre:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toggleMenu
{
    [self inputWidgetResign];
}

#pragma mark - UITextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitRegisterItemCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UnitRegisterItemCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleText = _dataSource[indexPath.row];
    if(indexPath.row == 5 || indexPath.row == 3){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textView.userInteractionEnabled = NO;
    }
    
   //手机号不可输入
    if(indexPath.row == 2){
        cell.textView.userInteractionEnabled = NO;
        cell.textView.text = gPersonInfo.StrTel;
        cell.textView.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    }
    
    if(indexPath.row == 4){
        cell.textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    cell.textView.delegate = self;
    cell.textView.returnKeyType= UIReturnKeyDone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != 5){
        return PXFIT_HEIGHT(100);
    }
    
    return _cellHeight < PXFIT_HEIGHT(100) ? PXFIT_HEIGHT(100) : _cellHeight;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3){
        //行业
        __weak typeof (self) wself = self;
        WorkTypeViewController* workTypeViewController = [[WorkTypeViewController alloc] init];
        workTypeViewController.workTypeStr = _workTypeStr;
        workTypeViewController.block = ^(NSString* result){
            __strong typeof(self) sself = wself;
            UnitRegisterItemCell* cell = [sself->_tableView cellForRowAtIndexPath:indexPath];
            _workTypeStr = result;
            cell.textView.text = _workTypeStr;
        };
        [self.navigationController pushViewController:workTypeViewController animated:YES];
    }
    
    if (indexPath.row == 5){
        //地址
        __weak typeof (self) wself = self;
        SelectAddressViewController* selectAddressVC = [[SelectAddressViewController alloc] init];
        selectAddressVC.addressStr = _address;
        [selectAddressVC getAddressArrayWithBlock:^(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor) {
            __strong typeof(self) sself = wself;
            UnitRegisterItemCell* cell = [sself->_tableView cellForRowAtIndexPath:indexPath];
            _address = address;
            cell.content = _address;
            sself->_cellHeight = cell.textView.frame.size.height;
            [sself->_tableView reloadData];
            [wself updateLayout];
            
            _locationCoordinate = coor;
        }];
        [self.navigationController pushViewController:selectAddressVC animated:YES];
    }
}

#pragma mark - Private Methods
-(void)loadData
{
    _dataSource = @[@" 单位名称", @" 负责人 ", @" 手机号 ", @" 行业  ", @" 员工人数", @" 单位地址"];
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
    _viewHeight = SCREEN_HEIGHT - keyboardBounds.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
       self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight);
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;//UIKeyboardFrameEndUserInfoKey
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
       self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _viewHeight + keyboardBounds.size.height);
    } completion:NULL];
}

-(void)updateLayout
{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(5*PXFIT_HEIGHT(100) + _cellHeight);
    }];
}

-(void)inputWidgetResign
{
    for (NSInteger index = 0; index < _dataSource.count; index++){
        NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
        UnitRegisterItemCell* cell = [_tableView cellForRowAtIndexPath:path];
        [cell.textView resignFirstResponder];
    }
}


@end
