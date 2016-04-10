//
//  PCheckAllPayView.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PCheckAllPayView.h"
#import <Masonry.h>
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "UIFont+Custom.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(0, -30, 0, 0)

@interface PCheckAllPayView()
{
    UIImageView *selectedImageView;
    UIButton    *selectBtn;
    UILabel     *moneyLabel;
    UIButton    *payMoneyBtn;
}
@end

@implementation PCheckAllPayView

- (instancetype)init
{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self initSubviews];
//    }
//    return self;
//}


- (void)initSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    selectedImageView = [[UIImageView alloc]init];
    [self addSubview:selectedImageView];
    selectedImageView.image = [UIImage imageNamed:@"tuoyuan"];
    [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.height.equalTo(@20);
    }];

    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectedImageView);
        make.left.equalTo(selectedImageView.mas_right);
        make.width.equalTo(@50);
        make.height.equalTo(@40);
    }];
    [selectBtn setTitle:@"全选" forState:UIControlStateNormal];

    payMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payMoneyBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [payMoneyBtn setBackgroundColor:[UIColor redColor]];
    [payMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payMoneyBtn addTarget:self action:@selector(payMoneyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payMoneyBtn];
    [payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.equalTo(@120);
    }];

    moneyLabel = [[UILabel alloc]init];
    [self addSubview:moneyLabel];
    moneyLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:18];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(selectBtn.mas_right).offset(20);
        make.right.equalTo(payMoneyBtn.mas_left).offset(-5);
    }];
    moneyLabel.text = [NSString stringWithFormat:@"合计: ¥%.2f", _money * _count];
}

- (void)selectBtnClicked:(UIButton *)sender
{
    if (_count != _allCount) {
        if ([_delegate respondsToSelector:@selector(selectAll)] && _delegate) {
            [_delegate selectAll];
        }
    }
    else{
        if ([_delegate respondsToSelector:@selector(deSelectAll)] && _delegate) {
            [_delegate deSelectAll];
        }
    }
}

- (void)payMoneyClicked:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(payAll)] && _delegate) {
        [_delegate payAll];
    }
}

- (void)setMoney:(float)money count:(NSInteger)count
{
    _money = money;
    _count = count;
    moneyLabel.text = [NSString stringWithFormat:@"合计: ¥%.2f", money * count];

    if (count == 0) {
        [payMoneyBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }
    else {
        [payMoneyBtn setTitle:[NSString stringWithFormat:@"去支付(%ld)", (long)count] forState:UIControlStateNormal];
    }

    if (count != _allCount) {
        selectedImageView.image = [UIImage imageNamed:@"tuoyuan"];
    }
    else {
        selectedImageView.image = [UIImage imageNamed:@"tuoyuanxuanzhong"];
    }
}
@end
