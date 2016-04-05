//
//  HCDateWheelView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/1.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HCDateWheelView.h"

#import <Masonry.h>
#import "Constants.h"

#import "UIButton+Easy.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"
#import "UIButton+HitTest.h"


#define Text_Font FIT_FONTSIZE(24)
#define Btn_Font FIT_FONTSIZE(23)

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)


@interface HCDateWheelView()<UIPickerViewDataSource, UIPickerViewAccessibilityDelegate>
{}
@end

@implementation HCDateWheelView
{
    UIPickerView        *_pickerView;
}


#pragma mark - UIViewController overrides
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        UIButton* sureBtn = [UIButton buttonWithTitle:@"确定"
                                                 font:[UIFont fontWithType:UIFontOpenSansSemibold size:Btn_Font]
                                            textColor:MO_RGBCOLOR(0, 174, 239)
                                      backgroundColor:[UIColor whiteColor]];
        [self addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(48));
            make.top.mas_equalTo(self).with.offset(PXFIT_HEIGHT(24));
        }];
        sureBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
        [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* cancelBtn = [UIButton buttonWithTitle:@"取消"
                                                   font:[UIFont fontWithType:UIFontOpenSansSemibold size:Btn_Font]
                                              textColor:MO_RGBCOLOR(0, 174, 239)
                                        backgroundColor:[UIColor whiteColor]];
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).with.offset(-PXFIT_WIDTH(48));
            make.centerY.mas_equalTo(sureBtn);
            make.height.mas_equalTo(sureBtn);
        }];
        cancelBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(sureBtn.mas_bottom).with.offset(PXFIT_HEIGHT(48));
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
    }
    return self;
}


#pragma mark - Action
-(void)sureBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosetDateStr:HourStr:)]){
        [self.delegate choosetDateStr:_ymdContentArr[[_pickerView selectedRowInComponent:0]] HourStr:_hContentArr[[_pickerView selectedRowInComponent:1]]];
    }
}

-(void)cancelBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelChoose)]){
        [self.delegate cancelChoose];
    }
}

#pragma mark - Setter & Getter
-(void)setCurrentHour:(NSString *)currentHour
{
    _currentHour = currentHour;
    NSInteger index;
    for (index = 0; index < _hContentArr.count - 1; ++ index){
        if ([_currentHour isEqualToString:_hContentArr[index]])
            break;
    }
    [_pickerView selectRow:index inComponent:1 animated:NO];
}

-(void)setCurrentYMD:(NSString *)currentYMD
{
    _currentYMD = currentYMD;
    NSInteger index;
    for (index = 0; index < _ymdContentArr.count - 1; ++ index){
        if ([_currentYMD isEqualToString:_ymdContentArr[index]])
            break;
    }
    [_pickerView selectRow:index inComponent:0 animated:NO];
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0){
        return _ymdContentArr.count;
    }else{
        return _hContentArr.count;
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0){
        return [_ymdContentArr objectAtIndex:row];
    }else{
        return [_hContentArr objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = 0.0;
    if (component == 0)
        componentWidth = SCREEN_WIDTH * 2 / 3;
    else
        componentWidth = SCREEN_WIDTH * 1 / 3;
    return componentWidth;
}



@end
