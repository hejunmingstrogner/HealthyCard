//
//  BRContractHistoryTBFootCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/5.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BRContractHistoryTBFootCell.h"
#import <Masonry.h>
#import "UIFont+Custom.h"
#import "UILabel+FontColor.h"
#import "Constants.h"
#import "UIColor+Expanded.h"

@interface BRContractHistoryTBFootCell()

@property (nonatomic, strong) UILabel *statusLabel; // 状态
@property (nonatomic, strong) UILabel *checkCountLabel;// 已检查数量

@end

@implementation BRContractHistoryTBFootCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_centerX);
    }];

    _checkCountLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_checkCountLabel];
    _checkCountLabel.textAlignment = NSTextAlignmentRight;
    [_checkCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView.mas_centerX);
    }];
}

- (void)setBrContract:(BRContract *)brContract
{
    UIFont *font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    NSString *status = [BRContract getTestStatus:brContract.testStatus];    //  得到检查状态
    UIColor *color = [UIColor colorWithRGBHex:HC_Gray_Text];

    [_statusLabel setText:@"状态:" Font:font WithEndText:status endTextColor:color];

    if (brContract.factCheckNum < 0) {
        brContract.factCheckNum = 0;
    }
    [_checkCountLabel setText:@"已检查" Font:font count:brContract.factCheckNum endColor:[UIColor redColor]];
}
@end
