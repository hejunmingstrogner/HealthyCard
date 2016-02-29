//
//  EditInfoViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/27.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "EditInfoViewController.h"

#import <Masonry.h>

#import "UIColor+Expanded.h"
#import "Constants.h"

#define Back_Ground_Color 0xfafafa

///@property (nonatomic ,copy) EditInfoBlock resultBlock;
@interface EditInfoViewController ()
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
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:Back_Ground_Color];
    
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
    _textField.text = _editInfoStr;
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
    //backbtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
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
    _block(_textField.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)backToPre:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end