//
//  BRContractTableHeaerCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BRContractTableHeaerCell.h"
#import <Masonry.h>

@implementation BRContractTableHeaerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _UnitNameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_UnitNameLabel];
    [_UnitNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(200);
    }];

    _statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLabel];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_UnitNameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(_UnitNameLabel);
        make.width.mas_equalTo(100);
    }];

    _addressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_addressLabel];
    _addressLabel.numberOfLines = 0;
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_UnitNameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setCellItem:(BRContract *)brContract
{
    _UnitNameLabel.text = brContract.cUnitName.length == 0? @"成都信息工程大学" : brContract.cUnitName;
    if (brContract.cCheckSiteID == nil) {
        _statusLabel.text = @"现场体检";
    }
    else
    {
        if (brContract.servicePoint != nil) {
            if (!brContract.servicePoint.startTime || !brContract.servicePoint.endTime) {
                _statusLabel.text = @"获取失败";
            }
            else {
                NSString *year = [self getYear_Month_DayByDate:brContract.servicePoint.startTime];
                NSString *start = [self getHour_MinuteByDate:brContract.servicePoint.startTime];
                NSString *end = [self getHour_MinuteByDate:brContract.servicePoint.endTime];
                _statusLabel.text = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
            }
        }
        else {
            _statusLabel.text = @"获取失败";
        }
    }
    _addressLabel.text = brContract.servicePoint.address;
}

// 计算时间 年月日
- (NSString *)getYear_Month_DayByDate:(NSDate *)itDate
{
    if (!itDate) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *time = [formatter stringFromDate:itDate];
    return time;
}

// 计算时间 时分
- (NSString *)getHour_MinuteByDate:(NSDate *)itDate
{
    if (!itDate) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:itDate];
    return time;
}

@end
