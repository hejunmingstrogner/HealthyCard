//
//  HealthyCertificateView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/21.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
