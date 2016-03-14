//
//  WorkTypeViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/1.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "WorkTypeViewController.h"
#import <Masonry.h>

#import "Constants.h"

#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"

#import "WorkTypeInfoModel.h"
#import "HttpNetworkManager.h"


#define Text_Font FIT_FONTSIZE(24)
#define Detail_Font FIT_FONTSIZE(23)
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)


@interface WorkTypeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray         *_dataSource;
    UITableView     *_industryTableView;
    UITextField     *_inputTextField;
    
    UILabel         *_tipLabel;
}

@end

@implementation WorkTypeViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgationBar];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:HC_Base_BackGround];
    
    UIView* inputTextFieldContainerView = [[UIView alloc] init];
    inputTextFieldContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputTextFieldContainerView];
    [inputTextFieldContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).with.offset(PXFIT_HEIGHT(10)+kStatusBarHeight+kNavigationBarHeight);
        make.height.mas_equalTo(PXFIT_HEIGHT(100));
    }];
    
    _inputTextField = [[UITextField alloc] init];
    _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputTextField.text = _workTypeStr;
    _inputTextField.font = [UIFont fontWithType:UIFontOpenSansRegular size:Text_Font];
    [inputTextFieldContainerView addSubview:_inputTextField];
    _inputTextField.backgroundColor = [UIColor whiteColor];
    _inputTextField.delegate = self;
    _inputTextField.returnKeyType = UIReturnKeyDone;
    _inputTextField.placeholder = @"请输入行业";
    [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inputTextFieldContainerView).with.offset(PXFIT_WIDTH(10));
        make.right.mas_equalTo(inputTextFieldContainerView).with.offset(-PXFIT_WIDTH(10));
        make.centerY.mas_equalTo(inputTextFieldContainerView);
        make.height.mas_equalTo(PXFIT_HEIGHT(100) - 2);
    }];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = @"已有行业";
    _tipLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Detail_Font];
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(PXFIT_WIDTH(20));
        make.top.mas_equalTo(inputTextFieldContainerView.mas_bottom).with.offset(PXFIT_HEIGHT(20));
    }];
    
    _industryTableView = [[UITableView alloc] init];
    _industryTableView.dataSource = self;
    _industryTableView.delegate = self;
    [_industryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:_industryTableView];
    [_industryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(_tipLabel.mas_bottom).with.offset(PXFIT_HEIGHT(20));
    }];
    
    [self loadData];
    _industryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerKeyboardNotification];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self cancelKeyboardNotification];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    self.title = @"行业信息修改";
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureBtnClicked:)];
    self.navigationItem.rightBarButtonItem = rightbtn;
}

#pragma mark - Action
-(void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureBtnClicked:(id)sender
{
    _block(_inputTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods
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
    [_industryTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).with.offset(-keyboardBounds.size.height);
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [_industryTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
    }];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Text_Font];
    WorkTypeInfoModel* workInfoModel = (WorkTypeInfoModel*)_dataSource[indexPath.row];
    cell.textLabel.text = workInfoModel.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkTypeInfoModel* workInfoModel = (WorkTypeInfoModel*)_dataSource[indexPath.row];
    _inputTextField.text = workInfoModel.name;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


@end
