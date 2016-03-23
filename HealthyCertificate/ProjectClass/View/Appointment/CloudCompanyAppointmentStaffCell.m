//
//  CloudCompanyAppointmentStaffCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudCompanyAppointmentStaffCell.h"

#import <Masonry.h>

#import "UIFont+Custom.h"
#import "UILabel+FontColor.h"
#import "UIColor+Expanded.h"
#import "Constants.h"

#define Cell_Font 23


@interface CloudCompanyAppointmentStaffCell()
{
    UILabel         *_countLabel;
}

@end

@implementation CloudCompanyAppointmentStaffCell

#pragma mark - Life Circle
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        titleLabel.text = @"体检员工";
        [self addSubview:titleLabel];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        _countLabel.text = [NSString stringWithFormat:@"已选%ld", _staffCount];
        [self addSubview:_countLabel];
        
        UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self addSubview:arrowImageView];
        
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(10);
        }];
        [titleLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        

        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.greaterThanOrEqualTo(titleLabel.mas_right);
        }];
        
       
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).with.offset(-10);
            make.centerY.mas_equalTo(self);
            make.left.greaterThanOrEqualTo(_countLabel.mas_right).with.offset(10);
        }];
        [arrowImageView setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

#pragma mark - Setter & Getter
-(void)setStaffCount:(NSInteger)staffCount{
    _staffCount = staffCount;

    [_countLabel setText:@"已选"
                    Font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)]
                   count:_staffCount
                endColor:MO_RGBCOLOR(0, 168, 234)];
}

@end
