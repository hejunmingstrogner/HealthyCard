//
//  HCWheelView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCWheelViewDelegate <NSObject>

-(void)sureBtnClicked:(NSString*)wheelText;
-(void)cancelButtonClicked;

@end

@interface HCWheelView : UIView

@property (nonatomic, strong) NSMutableArray* pickerViewContentArr;

@property (nonatomic, weak) id<HCWheelViewDelegate> delegate;

@property (nonatomic, strong) UIPickerView* pickerView;

@end
