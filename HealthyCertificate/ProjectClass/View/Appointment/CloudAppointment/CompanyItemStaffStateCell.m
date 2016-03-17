//
//  CompanyItemStaffStateCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CompanyItemStaffStateCell.h"

#import <Masonry.h>

#import "UILabel+Easy.h"
#import "UIFont+Custom.h"

#import "Constants.h"

@interface CompanyItemStaffStateCell()
{
    UILabel* _titleLabel;
}

@end


@implementation CompanyItemStaffStateCell

#define Cell_Font 23

#pragma mark - Life Circle
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithType:UIFontOpenSansRegular
                                                                     size:FIT_FONTSIZE(Cell_Font)]
                                           textColor:[UIColor blackColor]];
        _titleLabel.text = @"员工状态";
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self);
            make.left.mas_equalTo(self).with.offset(10);
        }];
        
        
        UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self).with.offset(-10);
        }];
    }
    return self;
}

-(void)setTitleText:(NSString *)titleText
{
    _titleLabel.text = titleText;
   // [_titleLabel sizeToFit];
}

@end
