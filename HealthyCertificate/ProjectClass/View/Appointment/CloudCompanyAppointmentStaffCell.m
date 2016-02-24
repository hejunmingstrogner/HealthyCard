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
        titleLabel.text = @"添加员工列表";
        [self addSubview:titleLabel];
        
        UILabel* countLabel = [[UILabel alloc] init];
        countLabel.text = [NSString stringWithFormat:@"%ld", _staffCount];
        [self addSubview:countLabel];
        
        UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:arrowImageView];
        
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(PXFIT_WIDTH(24));
        }];
        [titleLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        

        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
        }];
        
       
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).with.offset(-PXFIT_WIDTH(24));
            make.centerY.mas_equalTo(self);
        }];
        
    }
    return self;
}



@end
