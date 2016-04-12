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
#import "UIButton+HitTest.h"
#import "UIButton+Easy.h"
#import "NSString+Custom.h"
#import "Constants.h"
#import "RzAlertView.h"

#define Back_Ground_Color 0xfafafa
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

//#define LineEditFont FIT_FONTSIZE(30)
#define LineEditFont 15
///@property (nonatomic ,copy) EditInfoBlock resultBlock;
@interface EditInfoViewController () <UITextFieldDelegate>
{
    UITextField         *_textField;
    EditInfoBlock       _block;
    
    NSString            *_editInfoStr;
}
@property (nonatomic, assign) NSInteger textLength;         // 限制文本输入长度
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
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.returnKeyType = UIReturnKeyDone;
    [textFieldBackView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldBackView).with.offset(PXFIT_WIDTH(20));
        make.right.mas_equalTo(textFieldBackView).with.offset(-PXFIT_WIDTH(20));
        make.top.bottom.mas_equalTo(textFieldBackView);
    }];
    
    /*
     //联系人
     EDITINFO_COMPANY_LINKPERSON,
     //联系电话
     EDITINFO_COMPANY_LINKPHONE,
     //预约人数
     EDITINFO_COMPANY_APPOINTMENTCOUNT
     */
    
    switch (_editInfoType) {
        case EDITINFO_NAME:
        {
            self.title = @"姓名修改";
            _textField.placeholder = @"请输入姓名";
            _textLength = NAME_LENGTH;
        }
            break;
        case EDITINFO_IDCARD:
        {
            self.title = @"身份证号码修改";
            _textField.placeholder = @"请输入身份证号码";
            _textLength = IDCARD_LENGTH;
            break;
        }
        case EDITINFO_LINKPHONE:{
            self.title = @"电话号码修改";
            _textField.placeholder = @"请输入电话号码";
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            _textLength = TELPHONENO_LENGTH;
            break;
        }
        case EDITINFO_COMPANY_LINKPERSON:
        {
            self.title = @"联系人修改";
            _textField.placeholder = @"请输入姓名";
            _textLength = NAME_LENGTH;
            break;
        }
        case EDITINFO_COMPANY_LINKPHONE:
        {
            self.title = @"联系电话修改";
            _textField.placeholder = @"请输入电话号码";
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            _textLength = TELPHONENO_LENGTH;
            break;
        }
        case EDITINFO_COMPANY_APPOINTMENTCOUNT:
        {
            self.title = @"预约人数修改";
            _textField.placeholder = @"请输入电话号码";
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            _textLength = CGFLOAT_MAX;
            break;
        }
        default:
            break;
    }
    
    // 限制文本输入长度
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textField];
}
#pragma mark -限制文本输入长度
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_textField];
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;

    NSString *toBeString = textField.text;
    // 键盘输入模式
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _textLength) {
                textField.text = [toBeString substringToIndex:_textLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > _textLength) {
            textField.text = [toBeString substringToIndex:_textLength];
        }
    }
}


-(void)initNavgationBar{
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;

    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
    
    UIButton* completeBtn = [UIButton buttonWithTitle:@"完成"
                                              font:[UIFont fontWithType:UIFontOpenSansRegular size:17]
                                         textColor:[UIColor colorWithRGBHex:HC_Blue_Text]
                                   backgroundColor:[UIColor clearColor]];
    [completeBtn addTarget:self action:@selector(completeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
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
        if (_textField.text.length != 11) {
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

    NSString *_text = [_textField.text deleteSpaceWithHeadAndFootWithString];
    if (_text.length == 0) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"您还没有输入" removeDelay:3];
        _textField.text = _text;
        return;
    }
    if (_block) {
        _block(_text);
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
