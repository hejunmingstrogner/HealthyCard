//
//  HealthyCertificateView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/21.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomerTest.h"
#import "PersonInfoOfPhonePacket.h"

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
//点击修改头像
-(void)healthyImageClicked;

@end

@interface HealthyCertificateView : UIView

//下列信息修改的时候,需要得到以下信息
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
@property (nonatomic, strong) UIImageView* imageView;


@property (nonatomic, weak) id<HealthyCertificateViewDelegate> delegate;


//待处理项界面进入的时候，用该类来填充健康证信息
@property (nonatomic, strong) CustomerTest *customerTest;
//初始状态下用该用户预约的时候，用登录的gpersonInfo来填充数据
@property (nonatomic, strong) PersonInfoOfPhonePacket *personInfoPacket;

@end
