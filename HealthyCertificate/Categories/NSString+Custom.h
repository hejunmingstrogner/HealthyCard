//
//  NSString+Custom.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Custom)

/**
 *  将 两个string 用 sepString分隔
 *
 *  @param firstString  第一个字符串
 *  @param secondString 第二个字符串
 *  @param sepString    分隔符
 *
 *  @return 组合的字符串
 */
+(NSString*)combineString:(NSString*)firstString And:(NSString*)secondString With:(NSString*)sepString;

@end
