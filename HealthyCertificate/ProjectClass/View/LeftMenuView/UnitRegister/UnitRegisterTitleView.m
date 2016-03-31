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

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        UILabel* titleLabel = [UILabel labelWithText:@"单位信息"
                                                font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)]
                                           textColor:[UIColor colorWithRGBHex:HC_Gray_Text]];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        UIView* leftLineView = [[UIView alloc] init];
        [self addSubview:leftLineView];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(5);
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(titleLabel.mas_left).with.offset(-5);
            make.height.mas_equalTo(1);
        }];
        leftLineView.backgroundColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        
        UIView* rightLineView = [[UIView alloc] init];
        [self addSubview:rightLineView];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-5);
            make.centerY.equalTo(titleLabel);
            make.left.equalTo(titleLabel.mas_right).with.offset(5);
            make.height.mas_equalTo(1);
        }];
        rightLineView.backgroundColor = [UIColor colorWithRGBHex:HC_Gray_Text];
        
    
    }
    return self;
}



@end
