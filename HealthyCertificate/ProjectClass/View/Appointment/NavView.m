//
//  NavView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "NavView.h"
#import "Constants.h"
#import <Masonry.h>

#import "UIButton+Easy.h"
#import "UIFont+Custom.h"

@implementation NavView

#pragma mark - Setter & Getter

// < + titile + button
-(void)setNavTitle:(NSString *)navTitle{
    self.backgroundColor = MO_RGBCOLOR(255, 255, 255);
    
    UIButton* backBtn = [UIButton buttonWithNormalImageName:@"back" highlightImageName:@"back"];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).with.offset(8);
    }];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)];
    navTitleLabel.text = navTitle;
    [self addSubview:navTitleLabel];
    [navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).with.offset(8);
        make.centerY.mas_equalTo(self);
       // make.right.greaterThanOrEqualTo(sureButton.mas_left).with.offset(8);
    }];

    UIButton* sureButton = [UIButton buttonWithTitle:@"确定"
                                                font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(24)]
                                           textColor:MO_RGBCOLOR(0, 169, 234)
                                     backgroundColor:[UIColor clearColor]];
    [self addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).with.offset(-8);
        make.left.greaterThanOrEqualTo(navTitleLabel.mas_right).with.offset(8);
    }];
    [sureButton setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    [sureButton addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action
-(void)sureBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureBtnClicked)]){
        [self.delegate sureBtnClicked];
    }
}

-(void)backBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClicked)]){
        [self.delegate backBtnClicked];
    }
}

@end
