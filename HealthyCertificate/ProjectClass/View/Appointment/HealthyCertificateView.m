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
#import "NSString+Count.h"
#import "NSString+Count.h"

#import <Masonry.h>

#define Title_Size 24
#define Text_Size 23

@interface HealthyCertificateView()<UIGestureRecognizerDelegate>
{
    UIButton*       _nameBtn;
    UILabel*        _ageLabel;
    UIButton*       _sexBtn;
    UIButton*       _workTypeBtn;
    UIButton*       _idCardBtn;
    UILabel*        _orgLabel;
    UILabel*        _numLabel;
    
    UIButton*       _imageBtn;
}

@end

@implementation HealthyCertificateView

#pragma mark - Setter & Getter
- (void)setCustomerTest:(CustomerTest *)customerTest
{
    _customerTest = customerTest;
    
    _name = customerTest.custName;
    _age = [NSString getOldYears:customerTest.custIdCard];
    _gender = customerTest.sex == 0 ? @"男":@"女";
    _workType = customerTest.jobDuty;
    _idCard = customerTest.custIdCard;
    _org = @"";
    _num = @"";

    [_nameBtn setTitle:_name forState:UIControlStateNormal];
    _ageLabel.text = _age;
    [_sexBtn setTitle:_gender forState:UIControlStateNormal];
    [_workTypeBtn setTitle:_workType forState:UIControlStateNormal];
    [_idCardBtn setTitle:_idCard forState:UIControlStateNormal];
    _orgLabel.text = _org;
    _numLabel.text = _num;}

-(void)setPersonInfoPacket:(PersonInfoOfPhonePacket *)personInfoPacket
{
    _name = personInfoPacket.mCustName;
    _age = [NSString getOldYears:personInfoPacket.CustId];
    _gender = personInfoPacket.bGender == 0 ? @"男":@"女";
    _workType = personInfoPacket.cIndustry;
    _idCard = personInfoPacket.CustId;
    _org = @"";
    _num = @"";
    
    [_nameBtn setTitle:_name forState:UIControlStateNormal];
    _ageLabel.text = _age;
    [_sexBtn setTitle:_gender forState:UIControlStateNormal];
    [_workTypeBtn setTitle:_workType forState:UIControlStateNormal];
    [_idCardBtn setTitle:_idCard forState:UIControlStateNormal];
    _orgLabel.text = _org;
    _numLabel.text = _num;
}

-(void)setName:(NSString *)name
{
    _name = name;
    [_nameBtn setTitle:_name forState:UIControlStateNormal];
}

-(void)setGender:(NSString *)gender{
    _gender = gender;
    [_sexBtn setTitle:_gender forState:UIControlStateNormal];
}

-(void)setIdCard:(NSString *)idCard{
    _idCard = idCard;
    [_idCardBtn setTitle:_idCard forState:UIControlStateNormal];
}


#pragma mark - Life Circle
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
        titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Title_Size)];
        [titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(titleView);
        }];
        
        UIView* imageContainerView = [[UIView alloc] init];
        [self addSubview:imageContainerView];
        
//        UIImageView* picImageView = [[UIImageView alloc] init];
//        [picImageView setImage:[UIImage imageNamed:@"Avatar"]];
//        [imageContainerView addSubview:picImageView];
        
        _imageBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"Avatar"] highlightImage:[UIImage imageNamed:@"Avatar"]];
        [_imageBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [imageContainerView addSubview:_imageBtn];
        
        //左边的文字部分取一个UIView
        UIView* leftView = [[UIView alloc] init];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(20));
            make.top.mas_equalTo(titleView.mas_bottom);
            make.bottom.mas_equalTo(self);
           // make.right.mas_equalTo(imageContainerView.mas_left).with.offset(-PXFIT_WIDTH(20));
            make.width.mas_equalTo( (SCREEN_WIDTH-20)*2/3);
        }];
        
        [imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftView);
            make.left.mas_equalTo(leftView.mas_right).with.offset(PXFIT_WIDTH(20));
            make.right.mas_equalTo(self).mas_equalTo(-PXFIT_WIDTH(20));
        }];
        [imageContainerView setContentCompressionResistancePriority:753 forAxis:UILayoutConstraintAxisHorizontal];
        
        [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(imageContainerView);
        }];

    
        
        //姓名所占的第一行布局
        UIView* firstLineView = [[UIView alloc] init];
        [leftView addSubview:firstLineView];
        [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(leftView);
            make.height.mas_equalTo(PXFIT_HEIGHT(76));
            make.top.mas_equalTo(leftView.mas_top);
        }];
        
        UILabel* nameLabelTitle = [[UILabel alloc] init];
        nameLabelTitle.text = @"姓名 : ";
        nameLabelTitle.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [nameLabelTitle sizeToFit];
        [firstLineView addSubview:nameLabelTitle];
        
        _nameBtn = [UIButton buttonWithTitle:_name
                                        font:nil
                                   textColor:[UIColor blackColor]
                             backgroundColor:[UIColor clearColor]];
         _nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _nameBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [_nameBtn addTarget:self action:@selector(nameBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [firstLineView addSubview:_nameBtn];
        
        UILabel* ageLabelTitle = [[UILabel alloc] init];
        ageLabelTitle.text = @"年龄 : ";
        ageLabelTitle.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [ageLabelTitle sizeToFit];
        [firstLineView addSubview:ageLabelTitle];

        _ageLabel = [[UILabel alloc] init];
        _ageLabel.text = [NSString getOldYears:_idCard];
        _ageLabel.textColor = [UIColor colorWithRGBHex:0x6e6e6e];
        _ageLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [firstLineView addSubview:_ageLabel];
        
        [nameLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(firstLineView);
            make.left.mas_equalTo(firstLineView);
        }];
        [nameLabelTitle setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        
        [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabelTitle);
            make.right.mas_equalTo(ageLabelTitle.mas_left).with.offset(-5);
            make.left.mas_equalTo(nameLabelTitle.mas_right).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];

        [ageLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabelTitle);
            make.left.mas_equalTo(self.mas_left).with.offset(SCREEN_WIDTH*1/3);
            make.right.mas_equalTo(_ageLabel.mas_left).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        [ageLabelTitle setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabelTitle);
            make.right.lessThanOrEqualTo(firstLineView.mas_right).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        
        //性别所占的第二行布局
        UIView* secondeLineView = [[UIView alloc] init];
        [self addSubview:secondeLineView];
        [secondeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(leftView);
            make.height.mas_equalTo(PXFIT_HEIGHT(76));
            make.top.mas_equalTo(firstLineView.mas_bottom);
        }];
        
        UILabel* sexLabelTitle = [[UILabel alloc] init];
        sexLabelTitle.text = @"性别 : ";
        sexLabelTitle.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [sexLabelTitle sizeToFit];
        [secondeLineView addSubview:sexLabelTitle];
        
        _sexBtn = [UIButton buttonWithTitle:_gender
                                        font:nil
                                   textColor:[UIColor blackColor]
                             backgroundColor:[UIColor clearColor]];
        _sexBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        _sexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_sexBtn addTarget:self action:@selector(sexBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [secondeLineView addSubview:_sexBtn];
        
        UILabel* workTypeLabelTitle = [[UILabel alloc] init];
        workTypeLabelTitle.text = @"行业 : ";
        workTypeLabelTitle.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [secondeLineView addSubview:workTypeLabelTitle];
        
        _workTypeBtn = [[UIButton alloc] init];
        _workTypeBtn.titleLabel.text = _workType;
        _workTypeBtn.titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [_workTypeBtn addTarget:self action:@selector(industryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [secondeLineView addSubview:_workTypeBtn];
        
        [sexLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(secondeLineView);
            make.left.mas_equalTo(secondeLineView);
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
            make.right.mas_equalTo(_workTypeBtn.mas_left).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        [workTypeLabelTitle setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        [_workTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sexLabelTitle);
            make.right.lessThanOrEqualTo(secondeLineView.mas_right).with.offset(0);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        //身份证号
        UIView* thirdLineView = [[UIView alloc] init];
        [self addSubview:thirdLineView];
        [thirdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(leftView);
            make.height.mas_equalTo(PXFIT_HEIGHT(76));
            make.top.mas_equalTo(secondeLineView.mas_bottom);
        }];
        
        UILabel* idCardLabel = [[UILabel alloc] init];
        idCardLabel.text = @"身份证 : ";
        idCardLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [thirdLineView addSubview:idCardLabel];
        
        _idCardBtn = [UIButton buttonWithTitle:_idCard
                                          font:[UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)]
                                     textColor:[UIColor blackColor]
                               backgroundColor:[UIColor clearColor]];
        [_idCardBtn addTarget:self action:@selector(idCardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [thirdLineView addSubview:_idCardBtn];
        
        [idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(thirdLineView);
            make.centerY.mas_equalTo(thirdLineView);
            make.height.mas_equalTo(nameLabelTitle);
            make.right.mas_equalTo(_idCardBtn.mas_left);
        }];
        [idCardLabel setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        [_idCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(thirdLineView.mas_right).with.offset(0);
            make.centerY.mas_equalTo(idCardLabel);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        //发证机关
        UIView* fourthLineView = [[UIView alloc] init];
        [self addSubview:fourthLineView];
        [fourthLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(leftView);
            make.height.mas_equalTo(PXFIT_HEIGHT(76));
            make.top.mas_equalTo(thirdLineView.mas_bottom);
        }];
        
        UILabel* orgLabel = [[UILabel alloc] init];
        orgLabel.text = @"检查机构 : ";
        orgLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [fourthLineView addSubview:orgLabel];

        _orgLabel = [[UILabel alloc] init];
        _orgLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [fourthLineView addSubview:_orgLabel];
        
        [orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fourthLineView);
            make.centerY.mas_equalTo(fourthLineView);
            make.height.mas_equalTo(nameLabelTitle);
            make.right.mas_equalTo(_orgLabel.mas_left);
        }];
        [orgLabel setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(fourthLineView.mas_right).with.offset(0);
            make.centerY.mas_equalTo(orgLabel);
            make.height.mas_equalTo(nameLabelTitle);
        }];
        
        //证件编号
        UIView* fifthLineView = [[UIView alloc] init];
        [self addSubview:fifthLineView];
        [fifthLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(leftView);
            make.height.mas_equalTo(PXFIT_HEIGHT(76));
            make.top.mas_equalTo(fourthLineView.mas_bottom);
        }];
        
        
        UILabel* numLabel = [[UILabel alloc] init];
        numLabel.text = @"证件编号 : ";
        numLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [fifthLineView addSubview:numLabel];
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Text_Size)];
        [fifthLineView addSubview:_numLabel];
        
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fifthLineView);
            make.centerY.mas_equalTo(fifthLineView);
            make.height.mas_equalTo(nameLabelTitle);
            make.right.mas_equalTo(_numLabel.mas_left);
        }];
        [numLabel setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
        
       
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.lessThanOrEqualTo(fifthLineView.mas_right).with.offset(0);
            make.centerY.mas_equalTo(numLabel);
            make.bottom.mas_equalTo(leftView).with.offset(-PXFIT_HEIGHT(20));
            make.height.mas_equalTo(nameLabelTitle);
        }];
    }
    return self;
}


#pragma mark - Action
-(void)nameBtnClicked:(id)sender;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nameBtnClicked:)]){
        [self.delegate nameBtnClicked:_nameBtn.titleLabel.text];
    }
}


-(void)sexBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sexBtnClicked:)]){
        [self.delegate sexBtnClicked:_sexBtn.titleLabel.text];
    }
}


-(void)industryBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(industryBtnClicked:)]){
        [self.delegate industryBtnClicked:_workTypeBtn.titleLabel.text];
    }
}

-(void)idCardBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(idCardBtnClicked:)]){
        [self.delegate idCardBtnClicked:_idCard];
    }
}

-(void)imageBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(healthyImageClicked)]){
        [self.delegate healthyImageClicked];
    }
}

@end
