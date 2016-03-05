//
//  BRContractTableHeaerCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BRContractTableHeaerCell.h"
#import <Masonry.h>
#import "NSDate+Custom.h"
#import "UIFont+Custom.h"
#import "Constants.h"
#import "UIColor+Expanded.h"
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
    _UnitNameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    [_UnitNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(200);
    }];

    _statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLabel];
    _statusLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_UnitNameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(_UnitNameLabel);
//        make.width.mas_equalTo(100);
        make.left.equalTo(_UnitNameLabel.mas_right).offset(5);
    }];

    _addressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_addressLabel];
    _addressLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:15];
    _addressLabel.numberOfLines = 0;
    _addressLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_UnitNameLabel.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setCellItem:(BRContract *)brContract
{
    _UnitNameLabel.text = brContract.unitName;
    if (brContract.checkSiteID == nil) {
        _statusLabel.text = @"现场体检";
    }
    else
    {
        if (brContract.servicePoint != nil) {
            if (!brContract.servicePoint.startTime || !brContract.servicePoint.endTime) {
                _statusLabel.text = @"获取失败";
            }
            else {
                NSString *year = [NSDate getYear_Month_DayByDate:brContract.servicePoint.startTime/1000];
                NSString *start = [NSDate getHour_MinuteByDate:brContract.servicePoint.startTime/1000];
                NSString *end = [NSDate getHour_MinuteByDate:brContract.servicePoint.endTime/1000];
                _statusLabel.text = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
            }
        }
        else {
            _statusLabel.text = @"获取失败";
        }
    }
    _addressLabel.text = brContract.servicePoint.address;
}

@end
