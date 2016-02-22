//
//  BRContractTableFootCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BRContractTableFootCell.h"
#import <Masonry.h>

@implementation BRContractTableFootCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    UILabel *status = [[UILabel alloc]init];
    status.text = @"状态:";
    [self.contentView addSubview:status];
    status.font = [UIFont systemFontOfSize:13];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
    }];

    _statusLabel = [[UILabel alloc]init];
    _statusLabel.textColor = [UIColor grayColor];
    _statusLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(status.mas_right);
        make.bottom.top.equalTo(status);
        make.width.mas_equalTo(80);
    }];

    _orderedLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_orderedLabel];
    _orderedLabel.textAlignment = NSTextAlignmentRight;
    _orderedLabel.text = @"已预约:0";
    _orderedLabel.textColor = [UIColor grayColor];
    _orderedLabel.font = [UIFont systemFontOfSize:13];
    [_orderedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(status);
        make.left.equalTo(self.contentView.mas_centerX).offset(-20);
        make.width.mas_equalTo(60);
    }];

    _checkedLabel = [[UILabel alloc]init];
    _checkedLabel.textAlignment = NSTextAlignmentRight;
    _checkedLabel.textColor = [UIColor grayColor];
    _checkedLabel.font = [UIFont systemFontOfSize:13];
    _checkedLabel.text = @"已检查:0";
    [self.contentView addSubview:_checkedLabel];
    [_checkedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_orderedLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(_orderedLabel.mas_right).offset(10);
    }];
}

- (void)setCellItem:(BRContract *)brContract
{
    if ([brContract.cStatus isEqualToString:@"-1"]) {
        _statusLabel.text = @"未完成";
    }
    else if ([brContract.cStatus isEqualToString:@"3"]) {
        _statusLabel.text = @"全部已检";
    }
    else if ([brContract.cStatus isEqualToString:@"4"]) {
        _statusLabel.text = @"已出证";
    }
    else if ([brContract.cStatus isEqualToString:@"5"]) {
        _statusLabel.text = @"已评价";
    }
    _orderedLabel.text = [NSString stringWithFormat:@"已预约:%d", brContract.cRegCheckNum];
    _checkedLabel.text = [NSString stringWithFormat:@"已检查:%d", brContract.cFactCheckNum];
}
@end
