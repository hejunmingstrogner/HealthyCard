//
//  NSString+Custom.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

+(NSString*)combineString:(NSString*)firstString And:(NSString*)secondString With:(NSString*)sepString
{
    NSMutableString* resultString = [[NSMutableString alloc] init];
    [resultString appendString:firstString];
    [resultString appendString:sepString];
    [resultString appendString:secondString];
    return resultString;
}

@end
