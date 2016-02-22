//
//  HCRule.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCRule : NSObject

+(BOOL)isPhoneNumValidate:(NSString*)phoneNumber;

// 身份证合法性校验
+ (BOOL)validateIDCardNumber:(NSString *)value;

@end
