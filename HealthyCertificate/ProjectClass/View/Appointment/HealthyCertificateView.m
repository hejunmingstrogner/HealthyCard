//
//  HealthyCertificateView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/21.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HealthyCertificateView.h"
#import "Constants.h"

#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"

#import <Masonry.h>

@interface HealthyCertificateView()
{
    UIButton*        _nameBtn;
    UILabel*        _ageLabel;
    UIButton*        _sexBtn;
    UILabel*        _workTypeLabel;
    UITextField*    _idCardTextField;
    UILabel*        _orgLabel;
    UILabel*        _numLabel;
    
    UIImageView*    _picView;
}

@end

@implementation HealthyCertificateView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView* titleView = [[UIView alloc] init];
        [self addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(PXFIT_HEIGHT(80));
            make.top.mas_equalTo(self);
        }];
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"预防性健康检查合格证";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(30)];
        [titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(titleView);
        }];
        
        UIImageView* picImageView = [[UIImageView alloc] init];
        [picImageView setImage:[UIImage imageNamed:@"Avatar"]];
        [self addSubview:picImageView];
        
        //左边的文字部分取一个UIView
        UIView* leftView = [[UIView alloc] init];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(20));
            make.top.mas_equalTo(titleView.mas_bottom);
            make.bottom.mas_equalTo(self);
            make.right.mas_equalTo(picImageView.mas_left).with.offset(-PXFIT_WIDTH(20));
        }];
    
        
        //姓名所占的第一行布局
        UIView* firstLineView = [[UIView alloc] init];
        [leftView addSubview:firstLineView];
        [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(leftView);
            make.height.mas_equalTo(PXFIT_HEIGHT(76));
        }];
        
        UILabel* nameLabelTitle = [[UILabel alloc] init];
        nameLabelTitle.text = @"姓名 : ";
        nameLabelTitle.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [firstLineView addSubview:nameLabelTitle];
        
        _nameBtn = [UIButton buttonWithTitle:_name
                                        font:nil
                                   textColor:[UIColor blackColor]
                             backgroundColor:[UIColor clearColor]];
        [_nameBtn setTitle:@"张小二" forState:UIControlStateNormal];
        _nameBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [firstLineView addSubview:_nameBtn];
        
        UILabel* ageLabelTitle = [[UILabel alloc] init];
        ageLabelTitle.text = @"年龄 : ";
        ageLabelTitle.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [firstLineView addSubview:ageLabelTitle];

        _ageLabel = [[UILabel alloc] init];
        _ageLabel.text = @"30";
        _ageLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [firstLineView addSubview:_ageLabel];
        
        [nameLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(firstLineView);
            make.centerY.mas_equalTo(firstLineView);
        }];
        [nameLabelTitle setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        
        [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabelTitle);
            make.right.mas_equalTo(ageLabelTitle.mas_left).with.offset(-5);
            make.left.mas_equalTo(nameLabelTitle.mas_right).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        _nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [ageLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabelTitle);
            make.left.mas_equalTo(self.mas_left).with.offset(SCREEN_WIDTH*1/3);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabelTitle);
            make.right.mas_equalTo(leftView).with.offset(0);
            make.left.mas_equalTo(ageLabelTitle.mas_right).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        [_ageLabel setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        //性别所占的第二行布局
        UILabel* sexLabelTitle = [[UILabel alloc] init];
        sexLabelTitle.text = @"性别 : ";
        sexLabelTitle.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [sexLabelTitle sizeToFit];
        [leftView addSubview:sexLabelTitle];
        
        _sexBtn = [UIButton buttonWithTitle:_gender
                                        font:nil
                                   textColor:[UIColor blackColor]
                             backgroundColor:[UIColor clearColor]];
        [_sexBtn setTitle:@"男" forState:UIControlStateNormal];
        _sexBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        _sexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftView addSubview:_sexBtn];
        
        UILabel* workTypeLabelTitle = [[UILabel alloc] init];
        workTypeLabelTitle.text = @"工种 : ";
        workTypeLabelTitle.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [leftView addSubview:workTypeLabelTitle];
        
        _workTypeLabel = [[UILabel alloc] init];
        _workTypeLabel.text = @"餐饮服务";
        _workTypeLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [leftView addSubview:_workTypeLabel];
        
        [sexLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabelTitle.mas_bottom);
            make.left.mas_equalTo(leftView);
        }];
        [sexLabelTitle setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        
        [_sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sexLabelTitle);
            make.right.mas_equalTo(workTypeLabelTitle.mas_left).with.offset(-5);
            make.left.mas_equalTo(sexLabelTitle.mas_right).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        [workTypeLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sexLabelTitle);
            make.left.mas_equalTo(self.mas_left).with.offset(SCREEN_WIDTH*1/3);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        [_workTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sexLabelTitle);
            make.right.mas_equalTo(leftView).with.offset(0);
            make.left.mas_equalTo(workTypeLabelTitle.mas_right).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        [_workTypeLabel setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        
        //身份证号
        UILabel* idCardLabel = [[UILabel alloc] init];
        idCardLabel.text = @"身份证号 : ";
        idCardLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [leftView addSubview:idCardLabel];
        [idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView);
            make.top.mas_equalTo(sexLabelTitle.mas_bottom);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        [idCardLabel setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        _idCardTextField = [[UITextField alloc] init];
        _idCardTextField.text = @"513821199407301075";
        [leftView addSubview:_idCardTextField];
        [_idCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(idCardLabel.mas_right).offset(0);
            make.right.mas_equalTo(leftView);
            make.centerY.mas_equalTo(idCardLabel);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        //发证机关
        UILabel* orgLabel = [[UILabel alloc] init];
        orgLabel.text = @"发证机关 : ";
        orgLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [leftView addSubview:orgLabel];
        [orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView);
            make.top.mas_equalTo(idCardLabel.mas_bottom);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        [orgLabel setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        _orgLabel = [[UILabel alloc] init];
        _orgLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [leftView addSubview:_orgLabel];
        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(orgLabel.mas_right).offset(0);
            make.right.mas_equalTo(leftView);
            make.centerY.mas_equalTo(orgLabel);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        //证件编号
        UILabel* numLabel = [[UILabel alloc] init];
        numLabel.text = @"证件编号 : ";
        numLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [leftView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView);
            make.top.mas_equalTo(orgLabel.mas_bottom);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        [numLabel setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:FIT_FONTSIZE(26)];
        [leftView addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(numLabel.mas_right).offset(0);
            make.right.mas_equalTo(leftView);
            make.centerY.mas_equalTo(numLabel);
            make.bottom.mas_equalTo(leftView).with.offset(-PXFIT_HEIGHT(20));
            make.height.mas_equalTo(nameLabelTitle);
        }];
    
        [picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftView);
            make.left.greaterThanOrEqualTo(leftView.mas_right).with.offset(PXFIT_WIDTH(20));
            make.right.mas_equalTo(self).mas_equalTo(-PXFIT_WIDTH(20));
        }];
        [picImageView setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}


@end
