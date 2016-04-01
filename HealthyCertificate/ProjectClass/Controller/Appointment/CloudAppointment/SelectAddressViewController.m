//
//  SelectAddressViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "SelectAddressViewController.h"
#import <Masonry.h>
#import "LocationSearchModel.h"
#import "RzAlertView.h"

#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "NSString+Custom.h"
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation SelectAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubViews];

    [self getData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-rect.size.height);
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}

- (void)initNavgation
{
    self.title = @"完成地址信息";
    self.view.backgroundColor = [UIColor whiteColor];
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;

    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClicked:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmBtnClicked:(UIBarButtonItem *)sender
{
    _textField.text = [_textField.text deleteSpaceWithHeadAndFootWithString];
    if (_textField.text.length == 0) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您未填写信息" ActionTitle:@"明白了" ActionStyle:0];
        return ;
    }
    if ([_textField.text isEqualToString:_addressStr]) {
        [self.navigationController popViewControllerAnimated:YES];
    }

    if (_selectIndex < 0) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"请选择地址" ActionTitle:@"确认" ActionStyle:0];
    }
    else {
        CLLocationCoordinate2D coor;
        NSValue *value = _coordinateArray[_selectIndex];
        [value getValue:&coor];
        if (_block) {
            _block(_cityArray[_selectIndex], _districtArray[_selectIndex], _addressArray[_selectIndex], coor);
        }
        [self backToPre:nil];
    }
}

- (void)getAddressArrayWithBlock:(getAddressAndCoordinate)block
{
    _block = block;
}

- (void)getData
{
    if (_textField.text.length == 0) {
        return;
    }
    [[LocationSearchModel getInstance]getLocationsWithKeyText:_textField.text withBlock:^(NSArray *cityArray, NSArray *districtArray, NSArray *addressArray, NSArray *coordinateArray, NSError *error) {
        if (!error) {
            if (addressArray.count == 0) {
                return ;
            }
            _cityArray = [NSMutableArray arrayWithArray:cityArray];
            _districtArray = [NSMutableArray arrayWithArray:districtArray];;
            _addressArray = [NSMutableArray arrayWithArray:addressArray];
            _coordinateArray = [NSMutableArray arrayWithArray:coordinateArray];
            [_tableView reloadData];
        }
//        else {
//            [RzAlertView showAlertLabelWithTarget:self.view Message:@"出现未知错误" removeDelay:2];
//        }
    }];
}
- (void)initSubViews
{
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _addressArray = [NSMutableArray array];
    _selectIndex = -2;
    
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(75);
        make.left.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view).offset(5);
        make.height.mas_equalTo(44);
    }];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.8].CGColor;

    _textField = [[UITextField alloc]init];
    [self.view addSubview:_textField];
    _textField.text = _addressStr;
    [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _textField.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)textChanged:(UITextField *)textField
{
    _selectIndex = -1;
    if (textField.text.length != 0) {
        [self getData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_addressArray.count != 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return fmaxf(55, [self cellheight:[NSString stringWithFormat:@"%@", _addressArray[indexPath.row]]]);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"搜索结果";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithType:0 size:17];
        cell.detailTextLabel.font = [UIFont fontWithType:0 size:14];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _addressArray[indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@", _cityArray[indexPath.row], _districtArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textField.text = [NSString stringWithFormat:@"%@", _addressArray[indexPath.row]];
    [_textField resignFirstResponder];
    _selectIndex = indexPath.row;
}

- (CGFloat)cellheight:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:16];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+25;
    return he;
}

@end
