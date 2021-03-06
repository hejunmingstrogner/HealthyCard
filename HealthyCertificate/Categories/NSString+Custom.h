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

/**
 *  传入身份证得出生日期,并将日期转化为long long
 *
 *  @return long long 格式的出生日期
 */
- (long long)getLongLongBornDate;


/**
 *  传入 xxxx年xx月xx日,将其转化为long long
 *
 *  @return long long 格式的日期
 */
-(long long)convertDateStrToLongLong;

/**
 *  传入 xxxx年xx月xx日xx点,将其转化为long long
 *
 *  @return long long 格式的日期
 */
-(long long)convertDateStrWithHourToLongLong;

/**
 *  删除文字头尾的空格
 *
 *  @param text 要删除的原文本
 *
 *  @return 返回没有空格的文本
 */
- (NSString *)deleteSpaceWithHeadAndFootWithString;
@end
