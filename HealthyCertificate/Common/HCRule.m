//
//  HCRule.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HCRule.h"

@implementation HCRule

+(BOOL)isPhoneNumValidate:(NSString*)phoneNumber
{
    NSString*pattern =@"^1+[3578]+\\d{9}";
    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return isMatch;
}
@end
