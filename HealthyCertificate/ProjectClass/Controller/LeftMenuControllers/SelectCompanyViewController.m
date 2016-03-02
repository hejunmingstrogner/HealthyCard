//
//  SelectCompanyViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/2.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "SelectCompanyViewController.h"
#import <Masonry.h>
#import "RzAlertView.h"
#import "UIFont+Custom.h"
#import "HttpNetworkManager.h"
#import "BRServiceUnit.h"

@implementation SelectCompanyViewController

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
        make.top.equalTo(_textField.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-rect.size.height);
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)initNavgation
{
    self.title = @"搜索单位";
    self.view.backgroundColor = [UIColor whiteColor];
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;

    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClicked:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 确定
- (void)confirmBtnClicked:(UIBarButtonItem *)sender
{
    if (_selectIndex < 0) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"请选择地址" ActionTitle:@"确认" ActionStyle:0];
    }
    else {
        NSMutableDictionary *personinfo = [[NSMutableDictionary alloc]init];
        [personinfo setObject:gPersonInfo.mCustCode forKey:@"custCode"];
        [personinfo setObject:_textField.text forKey:@"unitName"];
        [personinfo setObject:((BRServiceUnit *)_companysArray[_selectIndex]).unitCode forKey:@"unitCode"];

        [[HttpNetworkManager getInstance]createOrUpdateUserinformationwithInfor:personinfo resultBlock:^(BOOL successed, NSError *error) {
            if (successed) {
                gPersonInfo.cUnitName = _textField.text;
                if (_updata) {
                    _updata(_textField.text);
                }
                [RzAlertView showAlertLabelWithTarget:self.view Message:@"修改成功" removeDelay:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backToPre:nil];
                });
            }
            else{
                [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您的修改未成功，请检查网络后重试" ActionTitle:@"明白了" ActionStyle:0];
            }
        }];
    }
}

- (void)isupdataCompany:(updataCompany)block
{
    _updata = block;
}

- (void)getData
{
    if (_textField.text.length == 0) {
        return;
    }
    [[HttpNetworkManager getInstance]fuzzQueryBRServiceUnitsByName:_textField.text resultBlock:^(NSArray *result, NSError *error) {
        if (!error) {
            if (result.count != 0) {
                _companysArray = [NSMutableArray arrayWithArray:result];
                [_tableView reloadData];
            }
        }
    }];

}
- (void)initSubViews
{
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
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
    [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _textField.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    _textField.text = _companyName;
    _textField.placeholder = @"请输入单位名称";

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
    if (_companysArray.count != 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _companysArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
        cell.textLabel.font = [UIFont fontWithType:0 size:16];
        cell.detailTextLabel.font = [UIFont fontWithType:0 size:14];
        cell.detailTextLabel.numberOfLines = 0;
    }
    cell.textLabel.text = ((BRServiceUnit *)_companysArray[indexPath.row]).unitName;
    cell.detailTextLabel.text = ((BRServiceUnit *)_companysArray[indexPath.row]).addr;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textField.text = [NSString stringWithFormat:@"%@", ((BRServiceUnit *)_companysArray[indexPath.row]).unitName];
    [_textField resignFirstResponder];
    _selectIndex = indexPath.row;
}

- (CGFloat)cellheight:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:16];
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+10;
    return he;
}

@end
