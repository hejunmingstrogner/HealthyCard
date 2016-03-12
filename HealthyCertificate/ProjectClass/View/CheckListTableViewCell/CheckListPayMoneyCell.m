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
    [_payMoneyBtn setBackgroundColor:[UIColor colorWithRed:1 green:155/255.0 blue:18/255.0 alpha:1]];
    [_payMoneyBtn setTitle:@"在线支付" forState:UIControlStateNormal];
}
@end
