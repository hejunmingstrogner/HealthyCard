//
//  PayInfoViewCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PayInfoViewCell.h"
#import <Masonry.h>
#import "Constants.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "UILabel+FontColor.h"
@interface PayInfoViewCell()

@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UILabel *payManNameLabel;
@property (nonatomic, strong) UILabel *getManNameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation PayInfoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _titlelabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(105*78/178);
        make.width.mas_equalTo(200);
    }];
    _titlelabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:18];

    _payManNameLabel = [[UILabel alloc]init];
    _payManNameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    _payManNameLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [self.contentView addSubview:_payManNameLabel];
    [_payManNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titlelabel.mas_bottom);
        make.left.right.equalTo(_titlelabel);
        make.height.mas_equalTo(50*78/178);
    }];

    _getManNameLabel = [[UILabel alloc]init];
    _getManNameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
    _getManNameLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [self.contentView addSubview:_getManNameLabel];
    [_getManNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payManNameLabel.mas_bottom);
        make.left.right.equalTo(_titlelabel);
        make.bottom.equalTo(self.contentView);
    }];

    _moneyLabel = [[UILabel alloc]init];
//    _moneyLabel.textColor = [UIColor colorWithRGBHex:0xff9d12];
    _moneyLabel.textAlignment = NSTextAlignmentRight;
//    _moneyLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:23];
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-PXFIT_WIDTH(24));
        make.left.equalTo(_titlelabel.mas_right);
    }];
}

- (void)setPayManName:(NSString *)payManName
{
    _payManName = payManName;
    _payManNameLabel.text = [NSString stringWithFormat:@"预约人:%@",payManName];
}

- (void)setGetManName:(NSString *)getManName
{
    _getManName = getManName;
    _getManNameLabel.text = [NSString stringWithFormat:@"收款方:%@",getManName];
}
- (void)setTitleName:(NSString *)titleName
{
    _titleName = titleName;
    _titlelabel.text = titleName;
}
- (void)setMoney:(NSString *)money
{
    _money = money;
//    _moneyLabel.text = [NSString stringWithFormat:@"¥%@", money];
    [_moneyLabel setText:@"金额    " Font:[UIFont fontWithType:UIFontOpenSansRegular size:20] WithEndText:[NSString stringWithFormat:@"¥%@", money] endTextColor:[UIColor colorWithRGBHex:0xff9d12]];
}
@end
