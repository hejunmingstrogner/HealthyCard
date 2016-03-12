//
//  AdviceViewController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "AdviceViewController.h"
#import "UIFont+Custom.h"
#import "RzAlertView.h"

#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"
#import <Masonry.h>
#import "UIColor+Expanded.h"
#import "Constants.h"
#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@implementation AdviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavgation];

    [self initSubviews];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    // 限制文本输入长度
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:_adviceTextView];
}

#pragma mark -限制文本输入长度
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:_adviceTextView];
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextView *textField = (UITextView *)obj.object;
    static NSInteger _textLength = 300;
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

// 键盘将要显示
- (void)keyboardWillShow:(NSNotification *)notif
{
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = CGRectMake(0, 0, _tableView.frame.size.width, self.view.frame.size.height - rect.size.height);
    }];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
// 键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)notif
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame =  self.view.frame;
    }];
}

- (void)initNavgation
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"意见或建议";
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isconnectionNet{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;

    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);

    if (!didRetrieveFlags)
    {
        return NO;
    }

    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

- (void)confirmClicked:(id)sender
{
    if(_adviceTextView.text.length == 0)
    {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"您还未填写完整" ActionTitle:@"确认" ActionStyle:0];
        return;
    }
    if (![self isconnectionNet]) {
        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"网络链接错误，请检查后重试" ActionTitle:@"确认" ActionStyle:0];
    }
    else {
        [self.view endEditing:YES];
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"您的反馈我们已收到，谢谢您的耐心使用" removeDelay:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self backToPre:nil];
        });
    }
}
// 关闭键盘
- (void)closeKeyBoard:(UIButton *)sender
{
    [self.view endEditing:YES];
}
- (void)initSubviews
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _adviceTextView = [[UITextView alloc]init];
    _adviceTextView.keyboardType = UIKeyboardTypeDefault;
    _adviceTextView.font = [UIFont fontWithType:0 size:15];
    _selectMistakeFlagArray = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];

    UIButton *confirmBtn = [UIButton buttonWithTitle:@"提   交" font:[UIFont fontWithType:UIFontOpenSansRegular size:17] textColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.height.mas_equalTo(40);
    }];
    confirmBtn.layer.cornerRadius = 4;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerview = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"header"];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerview addSubview:closeBtn];
    closeBtn.frame = headerview.frame;
    [closeBtn addTarget:self action:@selector(closeKeyBoard:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *gpsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gpsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
    gpsBtn.tag = 0;
    [gpsBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    gpsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [gpsBtn setTitle:@"GPS不能定位" forState:UIControlStateNormal];
    [gpsBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [gpsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [headerview addSubview:gpsBtn];
    [gpsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerview).offset(10);
        make.left.equalTo(headerview).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(130);
    }];

    UIButton *shanPinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shanPinBtn.tag = 1;
    [shanPinBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shanPinBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    shanPinBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
    [shanPinBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    shanPinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[shanPinBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 65, 5, 0)];
    [shanPinBtn setTitle:@"出现黑屏闪屏" forState:UIControlStateNormal];
    [headerview addSubview:shanPinBtn];
    [shanPinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerview).offset(10);
        make.right.equalTo(headerview).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(130);
    }];

    UIButton *softMistakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    softMistakeBtn.tag = 2;
    [softMistakeBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [softMistakeBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [softMistakeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    softMistakeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
    softMistakeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[softMistakeBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 65, 5, 0)];
    [softMistakeBtn setTitle:@"软件出错" forState:UIControlStateNormal];
    [headerview addSubview:softMistakeBtn];
    [softMistakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerview).offset(-10);
        make.left.equalTo(headerview).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(130);
    }];

    UIButton *workBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    workBtn.tag = 3;
    [workBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [workBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [workBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    workBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    workBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
    //[workBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 65, 5, 0)];
    [workBtn setTitle:@"功能不全" forState:UIControlStateNormal];
    [headerview addSubview:workBtn];
    [workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerview).offset(-10);
        make.right.equalTo(headerview).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(130);
    }];

    return headerview;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"请详细描述您发现的问题(最多300字)";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = @"您的意见或建议";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            [cell.contentView addSubview:_adviceTextView];
            [_adviceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(5, 15, 5, 15));
            }];
        }
        return cell;
    }
}

- (void)selectBtnClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([_selectMistakeFlagArray[sender.tag] isEqualToString:@"0"]) {
        _selectMistakeFlagArray[sender.tag] = @"1";
        [sender setImage:[UIImage imageNamed:@"xuanzhong_on"] forState:UIControlStateNormal];
    }
    else
    {
        _selectMistakeFlagArray[sender.tag] = @"0";
        [sender setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
@end
