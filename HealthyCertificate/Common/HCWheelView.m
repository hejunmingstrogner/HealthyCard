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

#define Text_Font FIT_FONTSIZE(24)
#define Btn_Font FIT_FONTSIZE(23)

@interface HCWheelView()<UIPickerViewDataSource, UIPickerViewAccessibilityDelegate>
{
}
@end


@implementation HCWheelView

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
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureBtnClicked:)]){
        [self.delegate sureBtnClicked:[_pickerViewContentArr objectAtIndex:[_pickerView selectedRowInComponent:0]]];
    }
}

-(void)cancelBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked)]){
        [self.delegate cancelButtonClicked];
    }
}

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

#pragma mark - Private Methods
-(void)setPickerViewContentArr:(NSMutableArray *)pickerViewContentArr{
    if (_pickerViewContentArr == nil){
        _pickerViewContentArr = [[NSMutableArray alloc] init];
    }
    [_pickerViewContentArr removeAllObjects];
    
    _pickerViewContentArr = pickerViewContentArr;
    
    [_pickerView reloadAllComponents];
}

@end
