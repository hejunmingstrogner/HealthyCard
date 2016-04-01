//
//  UnitRegisterTitleView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/31.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "UnitRegisterTitleView.h"

#import "UIFont+Custom.h"
#import "UILabel+Easy.h"
#import "UIColor+Expanded.h"

#import "Constants.h"

#import <Masonry.h>

@implementation UnitRegisterTitleView
{
    UILabel     *_titleLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        _titleLabel = [UILabel labelWithText:_title
                                                font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(26)]
                                           textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        UIView* leftLineView = [[UIView alloc] init];
        [self addSubview:leftLineView];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(5);
            make.centerY.equalTo(_titleLabel);
            make.right.equalTo(_titleLabel.mas_left).with.offset(-5);
            make.height.mas_equalTo(1);
        }];
        leftLineView.backgroundColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        
        UIView* rightLineView = [[UIView alloc] init];
        [self addSubview:rightLineView];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-5);
            make.centerY.equalTo(_titleLabel);
            make.left.equalTo(_titleLabel.mas_right).with.offset(5);
            make.height.mas_equalTo(1);
        }];
        rightLineView.backgroundColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        
    
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = _title;
}


@end
