//
//  HCWheelView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HCWheelView.h"
#import <Masonry.h>
#import "Constants.h"

#import "UIButton+Easy.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

@interface HCWheelView()<UIPickerViewDataSource, UIPickerViewAccessibilityDelegate>
{
    NSMutableArray* _pickerViewContentArr;
}
@end


@implementation HCWheelView

-(void)setFrame:(CGRect)frame{
    UIButton* sureBtn = [UIButton buttonWithTitle:@"确定"
                                             font:[UIFont fontWithType:UIFontOpenSansSemibold size:14]
                                        textColor:MO_RGBCOLOR(0, 174, 239)
                                  backgroundColor:[UIColor whiteColor]];
    [self addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(48));
        make.top.mas_equalTo(self).with.offset(PXFIT_HEIGHT(24));
    }];
    [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelBtn = [UIButton buttonWithTitle:@"取消"
                                               font:[UIFont fontWithType:UIFontOpenSansSemibold size:14]
                                          textColor:MO_RGBCOLOR(0, 174, 239)
                                    backgroundColor:[UIColor whiteColor]];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.offset(-PXFIT_WIDTH(48));
        make.top.mas_equalTo(self).with.offset(PXFIT_HEIGHT(24));
    }];
    [cancelBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    [self addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(sureBtn.mas_bottom).with.offset(PXFIT_HEIGHT(48));
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH*1/3);
    }];
}

#pragma mark - Action
-(void)sureBtnClicked:(id)sender
{}

-(void)cancelBtnClicked:(id)sender
{}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerViewContentArr.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerViewContentArr objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

@end
