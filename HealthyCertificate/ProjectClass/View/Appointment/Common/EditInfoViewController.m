//
//  EditInfoViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/27.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "EditInfoViewController.h"

#import <Masonry.h>
#import "HCRule.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "Constants.h"
#import "RzAlertView.h"

#define Back_Ground_Color 0xfafafa

#define LineEditFont FIT_FONTSIZE(30)

///@property (nonatomic ,copy) EditInfoBlock resultBlock;
@interface EditInfoViewController () <UITextFieldDelegate>
{
    UITextField         *_textField;
    EditInfoBlock       _block;
    
    NSString            *_editInfoStr;
}

@end

@implementation EditInfoViewController

//#pragma mark - Setter & Getter

#pragma mark - Public Method
-(void)setEditInfoText:(NSString *)text WithBlock:(EditInfoBlock)block
{
    _editInfoStr = text;
    _block = block;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgationBar];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MO_RGBCOLOR(240, 240, 242);
    
    UIView* textFieldBackView = [[UIView alloc] init];
    textFieldBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textFieldBackView];
    [textFieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).with.offset(PXFIT_HEIGHT(24) + kNavigationBarHeight + kStatusBarHeight);
        make.height.mas_equalTo(PXFIT_HEIGHT(96));
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.font = [UIFont fontWithType:UIFontOpenSansRegular size:LineEditFont];
    _textField.text = _editInfoStr;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [textFieldBackView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldBackView).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(textFieldBackView).with.offset(-PXFIT_WIDTH(20));
        make.top.bottom.mas_equalTo(textFieldBackView);
    }];
    
    switch (_editInfoType) {
        case EDITINFO_NAME:
        {
            self.title = @"姓名修改";
            _textField.placeholder = @"请输入姓名";
        }
            break;
        case EDITINFO_IDCARD:
        {
            self.title = @"身份证号码修改";
            _textField.placeholder = @"请输入身份证号码";
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case EDITINFO_LINKPHONE:{
            self.title = @"电话号码修改";
            _textField.placeholder = @"请输入电话号码";
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        default:
            break;
    }
    
   
}

-(void)initNavgationBar{
    // 返回按钮
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backbtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(completeBtnClicked:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
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

#pragma mark - Action
-(void)completeBtnClicked:(id)sender
{
    // 电话号码
    if (_editInfoType == EDITINFO_LINKPHONE) {
        if (_textField.text.length == 11) {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"电话号码位数不正确" removeDelay:3];
            return;
        }
    }

    if(_editInfoType == EDITINFO_IDCARD){
        BOOL isvalidate = [HCRule validateIDCardNumber:_textField.text];
        if (isvalidate == NO) {
            [RzAlertView showAlertLabelWithTarget:self.view Message:@"身份证信息不正确" removeDelay:3];
            return;
        }
    }
    if (_block) {
        _block(_textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFiled Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

@end
