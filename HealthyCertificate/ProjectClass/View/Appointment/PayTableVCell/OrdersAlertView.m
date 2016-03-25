//
//  OrdersAlertView.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "OrdersAlertView.h"
#import <Masonry.h>
#import "RzAlertView.h"
#import "UIColor+Expanded.h"
#import "Constants.h"
#import "UIFont+Custom.h"
@interface OrdersAlertView()

@property (nonatomic, strong) UIView   *alerView;        // 悲剧遮罩
@property (nonatomic, strong) UILabel  *titleLabel;         // 标题界面
@property (nonatomic, strong) UILabel  *warmingLabel;       // 提示信息
@property (nonatomic, strong) UILabel  *detialeLabel;       // 提示的详细信息

@property (nonatomic, strong) CustomButton  *cancleBtn;
@property (nonatomic, strong) CustomButton  *comfirmBtn;

@property (nonatomic, strong) CustomButton  *closeBtn;

@end
@implementation OrdersAlertView

+(instancetype)getinstance
{
    static OrdersAlertView *sharedOrdersAlertView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedOrdersAlertView = [[OrdersAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedOrdersAlertView;
}

- (void)openWithSuperView:(UIView *)superView Title:(NSString *)title warming:(NSString *)warmtitle Message:(NSString *)message withHandle:(clickedBlock)block
{
    [superView endEditing:YES];
    [superView addSubview:self];
    _titleLabel.text = title.length == 0? @"提示信息" :title;
    _warmingLabel.text = warmtitle.length == 0? @"您已经预约成功" : warmtitle;
    _detialeLabel.text = message.length == 0? @"您已经预约成功,是否立即线上支付?" : message;
    _resultBlock = block;
    [self show];
}

- (void)openWithSuperView:(UIView *)superView Message:(NSString *)message withHandle:(clickedBlock)block
{
    [superView endEditing:YES];
    [superView addSubview:self];
    _detialeLabel.text = message.length == 0? @"您已经预约成功,是否立即支付?" : message;
    _resultBlock = block;
    [self show];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self initSubView];
        [self newinitView];
    }
    return self;
}

- (void)initSubView
{
#define _ALERT_HEIGHT 200
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    _alerView = [[UIView alloc]init];
    [self addSubview:_alerView];
    _alerView.backgroundColor = [UIColor whiteColor];
    [_alerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.center.equalTo(self);
        make.height.mas_equalTo(_ALERT_HEIGHT);
    }];

    // 标题上的view
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor colorWithRGBHex:HC_Base_Blue];
    [_alerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_alerView);
        make.height.mas_equalTo(_ALERT_HEIGHT/5);
    }];

    _titleLabel = [[UILabel alloc]init];
    [titleView addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(titleView);
    }];

    _closeBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [titleView addSubview:_closeBtn];
    _closeBtn.tag = -1;
    [_closeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView).offset(-10);
        make.centerY.equalTo(titleView);
        make.height.width.mas_equalTo(30);
    }];
    [_closeBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];

    // 提示信息的view
    UIView *messageView = [[UIView alloc]init];
    [_alerView addSubview:messageView];
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.left.right.bottom.equalTo(_alerView);
    }];

    _warmingLabel = [[UILabel alloc]init];
    _warmingLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    [messageView addSubview:_warmingLabel];
    [_warmingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messageView).offset(20);
        make.top.equalTo(messageView);
        make.right.equalTo(messageView).offset(-20);
        make.height.mas_equalTo(_ALERT_HEIGHT/5);
    }];

    _detialeLabel = [[UILabel alloc]init];
    [messageView addSubview:_detialeLabel];
    _detialeLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    _detialeLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [_detialeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_warmingLabel.mas_bottom);
        make.left.right.height.equalTo(_warmingLabel);
    }];

    _cancleBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.tag = 0;
    [_cancleBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:158/255.0 blue:15/255.0 alpha:1]];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancleBtn.layer.masksToBounds = YES;
    _cancleBtn.layer.cornerRadius = 4;
    [messageView addSubview:_cancleBtn];
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(messageView).offset(-20);
        make.left.equalTo(messageView).offset(20);
        make.height.mas_equalTo(_ALERT_HEIGHT/5);
        make.width.mas_equalTo(80);
    }];
    [_cancleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    _comfirmBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_comfirmBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:158/255.0 blue:15/255.0 alpha:1]];
    [_comfirmBtn setTitle:@"支付" forState:UIControlStateNormal];
    _comfirmBtn.layer.masksToBounds = YES;
    _comfirmBtn.layer.cornerRadius = 4;
    [messageView addSubview:_comfirmBtn];
    _comfirmBtn.tag = 1;
    [_comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(messageView).offset(-20);
        make.right.equalTo(messageView).offset(-20);
        make.width.height.equalTo(_cancleBtn);
    }];
    [_comfirmBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self hideView];
}

- (void)newinitView{
#define _ALERT_HEIGHT 130
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    _alerView = [[UIView alloc]init];
    [self addSubview:_alerView];
    _alerView.backgroundColor = [UIColor whiteColor];
    _alerView.layer.masksToBounds = YES;
    _alerView.layer.cornerRadius = 5;
    [_alerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(280);
        make.center.equalTo(self);
        make.height.mas_equalTo(_ALERT_HEIGHT);
    }];

    _detialeLabel = [[UILabel alloc]init];
    [_alerView addSubview:_detialeLabel];
    _detialeLabel.textAlignment = NSTextAlignmentCenter;
    _detialeLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    _detialeLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [_detialeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_alerView);
        make.height.mas_equalTo(_ALERT_HEIGHT/2);
    }];

    _cancleBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.tag = 0;
    [_cancleBtn setBackgroundColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1]];

    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancleBtn.layer.masksToBounds = YES;
    _cancleBtn.layer.cornerRadius = 4;
    [_alerView addSubview:_cancleBtn];
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_alerView).offset(-10);
        make.left.equalTo(_alerView).offset(20);
        make.height.mas_equalTo(_ALERT_HEIGHT/2 - 20);
        make.width.mas_equalTo(100);
    }];
    [_cancleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    _comfirmBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_comfirmBtn setBackgroundColor:[UIColor colorWithRed:43/255.0 green:148/255.0 blue:235/255.0 alpha:1]];
    [_comfirmBtn setTitle:@"支付" forState:UIControlStateNormal];
    _comfirmBtn.layer.masksToBounds = YES;
    _comfirmBtn.layer.cornerRadius = 4;
    [_alerView addSubview:_comfirmBtn];
    _comfirmBtn.tag = 1;
    [_comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_cancleBtn);
        make.right.equalTo(_alerView).offset(-20);
        make.width.height.equalTo(_cancleBtn);
    }];
    [_comfirmBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *fengelabel = [[UILabel alloc]init];
    [_alerView addSubview:fengelabel];
    [fengelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detialeLabel.mas_bottom);
        make.left.equalTo(_cancleBtn);
        make.right.equalTo(_comfirmBtn);
        make.height.mas_equalTo(0.5);
    }];
    fengelabel.backgroundColor = [UIColor grayColor];

    [self hideView];
}


- (void)btnClicked:(CustomButton *)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(_resultBlock) {
            _resultBlock(sender.tag);
        }
    });
    [self close];
}

- (void)show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self showView];
    } completion:nil];
}

- (void)close
{
    [UIView animateWithDuration:0.3 animations:^{
        _alerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
    } completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self removeFromSuperview];
    });
}

- (void)hideView
{
    self.hidden = YES;
    _alerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
}

- (void)showView
{
    _alerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
}
@end
