//
//  HCDateWheelView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/1.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HCDateWheelViewDelegate <NSObject>

-(void)choosetDateStr:(NSString*)ymdStr HourStr:(NSString*)hourStr;
-(void)cancelChoose;

@end


@interface HCDateWheelView : UIView

//年月日滚轮
@property (nonatomic, copy) NSArray* ymdContentArr;

//小时选择滚轮
@property (nonatomic, copy) NSArray* hContentArr;

@property (nonatomic, copy) NSString* currentYMD;
@property (nonatomic, copy) NSString* currentHour;



@property (nonatomic, weak) id<HCDateWheelViewDelegate> delegate;

@end
