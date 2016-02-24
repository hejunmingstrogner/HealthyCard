//
//  CloudCompanyAppointmentCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CloudCompanyAppointmentCell.h"

#import "UIFont+Custom.h"
#import "Constants.h"

#import <Masonry.h>

#define Cell_Font 23

@implementation CloudCompanyAppointmentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textField = [[UITextField alloc] init];
        self.textField.textColor = [UIColor blackColor];
        self.textField.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).with.offset(10);
        }];
    }
    return self;
}



@end
