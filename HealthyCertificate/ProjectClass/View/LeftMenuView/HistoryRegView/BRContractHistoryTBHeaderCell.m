//
//  BRContractHistoryTBHeaderCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/5.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BRContractHistoryTBHeaderCell.h"
#import <Masonry.h>
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "Constants.h"
#import "NSDate+Custom.h"

@interface BRContractHistoryTBHeaderCell()

@property (nonatomic, strong) UILabel *unitNamelabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation BRContractHistoryTBHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _unitNamelabel = [[UILabel alloc]init];
    [self.contentView addSubview:_unitNamelabel];
    [_unitNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-[UIScreen mainScreen].bounds.size.width*2/3);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
    _unitNamelabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];

    _timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_unitNamelabel);
        make.left.equalTo(_unitNamelabel.mas_right);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];

    _addressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_unitNamelabel.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(_unitNamelabel);
        make.right.equalTo(_timeLabel.mas_right);
    }];
    _addressLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    _addressLabel.textColor = [UIColor colorWithARGBHex:HC_Gray_Text];
}


- (void)setBrContract:(BRContract *)brContract
{
    _brContract = brContract;
    _unitNamelabel.text = brContract.unitName;
    _addressLabel.text = brContract.servicePoint.address;

    _timeLabel.text = [NSString stringWithFormat:@"%@~%@", [NSDate getHour_MinuteByDate:brContract.regBeginDate/1000], [NSDate getHour_MinuteByDate:brContract.regEndDate/1000]];
}
@end
