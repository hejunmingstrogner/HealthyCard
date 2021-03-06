//
//  HealthyCertificateOrderInfoView.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HealthyCertificateOrderInfoView.h"
#import "UIFont+Custom.h"
#import "Constants.h"
#import "UIColor+Expanded.h"

@implementation HealthyCertificateOrderInfoView


#pragma mark view initializations
- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titleArray
{
    if(self = [self initWithFrame:frame])
    {
        _titleArray = titleArray;
    }
    return self;
}

- (void)initSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.3].CGColor;
    self.layer.borderWidth = 0.5;
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"预约信息", @"体检服务点"]];
    [self addSubview:_segmentControl];
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(self.frame.size.width/2);
        make.height.mas_equalTo(self.frame.size.height/4-20);
    }];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor colorWithRGBHex:HC_Base_Blue];
//    _segmentControl.layer.masksToBounds = YES;
//    _segmentControl.layer.cornerRadius = 5;
    [_segmentControl addTarget:self action:@selector(segmentControlClicked:) forControlEvents:UIControlEventValueChanged];

    UIView *backview = [[UIView alloc]init];
    [self addSubview:backview];
    backview.backgroundColor = [UIColor grayColor];
    backview.alpha = 0.4;
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(11);
        make.right.equalTo(self).offset(-11);
        make.top.equalTo(self).offset(self.frame.size.height/4-1);
        make.height.mas_equalTo(self.frame.size.height/2+ 10);
    }];
    
    _timeBtn = [[CustomButton alloc]init];
    [self addSubview:_timeBtn];
    [_timeBtn setImage:[UIImage imageNamed:@"shijian"] forState:UIControlStateNormal];
    
    [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_timeBtn setBackgroundColor:[UIColor whiteColor]];
    _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _timeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, self.frame.size.height/4-5);
    _timeBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 5);
    _timeBtn.titleLabel.font = [UIFont fontWithType:1 size:14];
    
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.frame.size.height/4);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(self.frame.size.height/4-1);
    }];
    

    _addressBtn = [[CustomButton alloc]init];
    [self addSubview:_addressBtn];
    [_addressBtn setImage:[UIImage imageNamed:@"dizhis"] forState:UIControlStateNormal];

    [_addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addressBtn setBackgroundColor:[UIColor whiteColor]];
    _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _addressBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, self.frame.size.height/4-5);
    _addressBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 5);
    _addressBtn.titleLabel.font = [UIFont fontWithType:1 size:14];

    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_timeBtn.mas_bottom).offset(1);
        make.left.right.height.equalTo(_timeBtn);
        
    }];

    _phoneBtn = [[CustomButton alloc]init];
    [self addSubview:_phoneBtn];
    [_phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];

    [_phoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_phoneBtn setBackgroundColor:[UIColor whiteColor]];
    _phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, self.frame.size.height/4-5);
    _phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 5);
    _phoneBtn.titleLabel.font = [UIFont fontWithType:1 size:14];

    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressBtn.mas_bottom).offset(1);
        make.left.right.height.equalTo(_timeBtn);
    }];
}


#pragma mark - Action
- (void)segmentControlClicked:(UISegmentedControl *)sender
{
    [self setItem];
}

#pragma mark - Setter & Getter
- (void)setBrContract:(BRContract *)brContract{
    _brContract = brContract;
    [self setItem];
}

- (void)setCutomerTest:(CustomerTest *)cutomerTest
{
    _cutomerTest = cutomerTest;
    [self setItem];
}

-(void)setTimeBtnTxtColor:(UIColor *)timeBtnTxtColor{
    _timeBtnTxtColor = timeBtnTxtColor;
    [_timeBtn setTitleColor:_timeBtnTxtColor forState:UIControlStateNormal];
}

-(void)setAddressBtnTxtColor:(UIColor *)addressBtnTxtColor{
    _addressBtnTxtColor = addressBtnTxtColor;
    [_addressBtn setTitleColor:_addressBtnTxtColor forState:UIControlStateNormal];
}

-(void)setPhoneBtnTxtColor:(UIColor *)phoneBtnTxtColor{
    _phoneBtnTxtColor = phoneBtnTxtColor;
    [_phoneBtn setTitleColor:_phoneBtnTxtColor forState:UIControlStateNormal];
}

#pragma mark - Private Methods
- (void)setItem
{
    NSInteger index = _segmentControl.selectedSegmentIndex;
    if (index == 0) {
        if (_brContract) {
            [_addressBtn setTitle:_brContract.regPosAddr forState:UIControlStateNormal];
                        
            if (!_brContract.regBeginDate || !_brContract.regEndDate) {
                [_timeBtn setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                NSString *year = [NSDate getYear_Month_DayByDate:_brContract.regBeginDate/1000];
                NSString *end = [NSDate getYear_Month_DayByDate:_brContract.regEndDate/1000];
                NSString *time = [NSString stringWithFormat:@"%@~%@",year, end];
                [_timeBtn setTitle:time forState:UIControlStateNormal];
            }

            [_phoneBtn setTitle:_brContract.linkPhone forState:UIControlStateNormal];
        }
        else {
            [_addressBtn setTitleColor:_addressBtnTxtColor forState:UIControlStateNormal];
            [_timeBtn setTitleColor:_timeBtnTxtColor forState:UIControlStateNormal];
            [_phoneBtn setTitleColor:_phoneBtnTxtColor forState:UIControlStateNormal];
            
            
            [_addressBtn setTitle:_cutomerTest.regPosAddr forState:UIControlStateNormal];
            if (_cutomerTest.servicePoint == nil || _cutomerTest.servicePoint.type == 0){
                //单位统一预约
                [_timeBtn setTitle:[NSDate converLongLongToChineseStringDateWithHour:_cutomerTest.regTime/1000] forState:UIControlStateNormal];
            }else{
                //移动
                NSString *year = [NSDate getYear_Month_DayByDate:_cutomerTest.servicePoint.startTime/1000];
                NSString *start = [NSDate getHour_MinuteByDate:_cutomerTest.servicePoint.startTime/1000];
                NSString *end = [NSDate getHour_MinuteByDate:_cutomerTest.servicePoint.endTime/1000];
                NSString *timestatus = [NSString stringWithFormat:@"%@(%@~%@)", year, start, end];
                [_timeBtn setTitle:timestatus forState:UIControlStateNormal];
            }
            [_phoneBtn setTitle:_cutomerTest.linkPhone forState:UIControlStateNormal];
        }
    }
    else if(index == 1) {
        if (_brContract) {
            [_addressBtn setTitle:_brContract.servicePoint.address forState:UIControlStateNormal];
            if (!_brContract.servicePoint.startTime || !_brContract.servicePoint.endTime) {
                [_timeBtn setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                NSString *year = [NSDate getYear_Month_DayByDate:_brContract.servicePoint.startTime/1000];
                NSString *end = [NSDate getYear_Month_DayByDate:_brContract.servicePoint.endTime/1000];
                NSString *time = [NSString stringWithFormat:@"%@~%@",year, end];
                [_timeBtn setTitle:time forState:UIControlStateNormal];
            }
            [_phoneBtn setTitle:_brContract.servicePoint.leaderPhone forState:UIControlStateNormal];
        }
        else {
            if (_cutomerTest.servicePoint == nil){
                [_addressBtn setTitleColor:[UIColor colorWithRGBHex:HC_Gray_Text] forState:UIControlStateNormal];
                [_phoneBtn setTitle:@"" forState:UIControlStateNormal];
                [_addressBtn setTitle:@"现场体检" forState:UIControlStateNormal];
                [_timeBtn setTitleColor:[UIColor colorWithRGBHex:HC_Gray_Text] forState:UIControlStateNormal];
                [_phoneBtn setTitleColor:[UIColor colorWithRGBHex:HC_Gray_Text] forState:UIControlStateNormal];
                return;
            }
            
            [_addressBtn setTitleColor:[UIColor colorWithRGBHex:HC_Gray_Text] forState:UIControlStateNormal];
            [_timeBtn setTitleColor:[UIColor colorWithRGBHex:HC_Gray_Text] forState:UIControlStateNormal];
            [_phoneBtn setTitleColor:[UIColor colorWithRGBHex:HC_Gray_Text] forState:UIControlStateNormal];
            
            [_addressBtn setTitle:_cutomerTest.servicePoint.address forState:UIControlStateNormal];
            
            if (_cutomerTest.servicePoint.type == 1){
                //移动服务点
                NSString *year = [NSDate getYear_Month_DayByDate:_cutomerTest.servicePoint.startTime/1000];
                NSString *hour1 = [NSDate getHour_MinuteByDate:_cutomerTest.servicePoint.startTime/1000];
                NSString *end = [NSDate getHour_MinuteByDate:_cutomerTest.servicePoint.endTime/1000];
                NSString *time = [NSString stringWithFormat:@"%@(%@~%@)",year, hour1, end];
                [_timeBtn setTitle:time forState:UIControlStateNormal];
                if (_cutomerTest.servicePoint.brOutCheckArrange.leaderPhone == nil || [_cutomerTest.servicePoint.brOutCheckArrange.leaderPhone isEqualToString:@""]){
                    [_phoneBtn setTitle:_cutomerTest.servicePoint.brOutCheckArrange.driverPhone forState:UIControlStateNormal];
                }else{
                    [_phoneBtn setTitle:_cutomerTest.servicePoint.leaderPhone forState:UIControlStateNormal];
                }
            }
            else{
                //固定服务点
                NSString* timeStatus = [NSString stringWithFormat:@"工作日(%@~%@)", [NSDate getHour_MinuteByDate:_cutomerTest.servicePoint.startTime/1000],
                 [NSDate getHour_MinuteByDate:_cutomerTest.servicePoint.endTime/1000]];
                [_timeBtn setTitle:timeStatus forState:UIControlStateNormal];
                [_phoneBtn setTitle:_cutomerTest.servicePoint.leaderPhone forState:UIControlStateNormal];
            }
            
        }

    }
}
@end
