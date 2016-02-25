//
//  HealthyCertificateView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/21.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HealthyCertificateViewDelegate <NSObject>

@optional
//点击姓名
-(void)nameBtnClicked:(NSString*)name;
//点击性别
-(void)sexBtnClicked:(NSString*)gender;
//点击行业
-(void)industryBtnClicked:(NSString*)industry;
//点击身份证
-(void)idCardBtnClicked:(NSString*)idCard;

@end

@interface HealthyCertificateView : UIView

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* age;
@property (nonatomic, copy) NSString* gender;
//工种
@property (nonatomic, copy) NSString* workType;
//身份证
@property (nonatomic, copy) NSString* idCard;
//发证机关
@property (nonatomic, copy) NSString* org;
//证件编号
@property (nonatomic, copy) NSString* num;
//头像
@property (nonatomic, copy) NSString* picStr;

@property (nonatomic, weak) id<HealthyCertificateViewDelegate> delegate;

@end
