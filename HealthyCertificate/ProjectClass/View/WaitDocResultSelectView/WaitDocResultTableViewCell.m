//
//  WaitDocResultTableViewCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "WaitDocResultTableViewCell.h"
#import <Masonry.h>

@implementation WaitDocResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _countAndTimeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_countAndTimeLabel];
    _countAndTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_countAndTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.center.equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.frame.size.width/3);
    }];

    _titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(_countAndTimeLabel.mas_left);
    }];

    _statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLabel];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(_countAndTimeLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}


- (void)setCellItem:(WaitDocResultSelectItem *)waitItem
{
    _titleLabel.text = waitItem.proDetail;
    if (waitItem.countAndTime == nil || [waitItem.countAndTime isEqualToString:@""]) {
        _countAndTimeLabel.text = @"－－";
    }
    else {
        _countAndTimeLabel.text = waitItem.countAndTime;
    }
    _statusLabel.text = waitItem.status;
    if ([waitItem.status isEqualToString:@"已检"]) {
        _statusLabel.textColor = [UIColor grayColor];
    }
    else if ([waitItem.status isEqualToString:@"排队"]) {
        _statusLabel.textColor = [UIColor redColor];
    }
    else if ([waitItem.status isEqualToString:@"在检"]) {
        _statusLabel.textColor = [UIColor greenColor];
    }
}
@end
