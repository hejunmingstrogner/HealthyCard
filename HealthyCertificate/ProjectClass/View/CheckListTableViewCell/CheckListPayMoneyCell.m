//
//  CheckListPayMoneyCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/12.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CheckListPayMoneyCell.h"
#import <Masonry.h>
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

@implementation CheckListPayMoneyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSub];
    }
    return self;
}

- (void)initSub
{
    _payMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_payMoneyBtn];
    [_payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.width.mas_equalTo(80);
    }];
    _payMoneyBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    _payMoneyBtn.layer.masksToBounds = YES;
    _payMoneyBtn.layer.cornerRadius = 4;

    _cancelAppointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_cancelAppointBtn];
    [_cancelAppointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(_payMoneyBtn);
        make.right.equalTo(_payMoneyBtn.mas_left).offset(-20);
        make.centerY.equalTo(_payMoneyBtn);
    }];
    _cancelAppointBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    _cancelAppointBtn.layer.masksToBounds = YES;
    _cancelAppointBtn.layer.cornerRadius = 4;
    [_cancelAppointBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [_cancelAppointBtn setBackgroundColor:[UIColor colorWithRGBHex:0xff4200]];
}

- (void)setPayMoney:(float)payMoney
{
    _payMoney = payMoney;

    if (payMoney > 0) {
        [_payMoneyBtn setTitle:@"已支付" forState:UIControlStateNormal];
        [_payMoneyBtn setBackgroundColor:[UIColor colorWithRed:95/255.0 green:177/255.0 blue:58/255.0 alpha:1]];
        _payMoneyBtn.tag = -1;
    }
    else {
        [_payMoneyBtn setTitle:@"在线支付" forState:UIControlStateNormal];
        [_payMoneyBtn setBackgroundColor:[UIColor colorWithRed:1 green:155/255.0 blue:18/255.0 alpha:1]];
    }
}
@end
