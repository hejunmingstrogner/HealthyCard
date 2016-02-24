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
#import "Constants.h"

#define Cell_Font 23

@implementation CloudCompanyAppointmentStaffCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        titleLabel.text = @"添加员工列表";
        [self addSubview:titleLabel];
        
        UILabel* countLabel = [[UILabel alloc] init];
        countLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        countLabel.text = [NSString stringWithFormat:@"已添加%ld", _staffCount];
        [self addSubview:countLabel];
        
        UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self addSubview:arrowImageView];
        
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(PXFIT_WIDTH(24));
        }];
        [titleLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        

        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.greaterThanOrEqualTo(titleLabel.mas_right);
        }];
        
       
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).with.offset(-PXFIT_WIDTH(24));
            make.centerY.mas_equalTo(self);
            make.left.greaterThanOrEqualTo(countLabel.mas_right).with.offset(PXFIT_WIDTH(24));
        }];
        [arrowImageView setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

@end
