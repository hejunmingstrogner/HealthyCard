//
//  NSDate+Custom.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/20.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Custom)


/**
 *  获得后面连续几天的日期
 *
 *  @param beginDate 当前日期
 *  @param serverDays 后续天数
 *
 *  @return 存放连续几天的日期数组
 */
- (NSMutableArray*)nextServerDays:(NSInteger)serverDays;

/**
 *  将Date转化为 xxxx年xx月xx日
 *
 *  @return 格式化后的字符串
 */
- (NSString* )formatDateToChineseString;


/**
 *  将 xxxx年xx月xx日 转化为 Date
 *
 *  @param dateStr xxxx年xx月xx日
 *
 *  @return Date
 */
+ (NSDate*)formatDateFromChineseString:(NSString*)dateStr;

/**
 *  得到接下来第几天的NSDate
 *
 *  @param interval 间隔的天数
 *
 *  @return NSDate
 */
- (NSDate* )getDateWithInternel:(NSInteger)interval;

/**
 *  得到接下来第几天的String
 *
 *  @param interval 间隔的天数
 *
 *  @return String
 */
- (NSString* )getDateStringWithInternel:(NSInteger)interval;

/**
 *  将date转换成long long
 *
 *  @return long long 型的date
 */
-(long long)convertToLongLong;


/**
 *  将long long转化为 NSDate
 *
 *  @param dateLong long long型的日期
 *
 *  @return xxxx年xx月xx日
 */
+(NSString*)converLongLongToChineseStringDate:(long long)dateLong;

// 计算时间 年月日 返回 XX年XX月XX日
+ (NSString *)getYear_Month_DayByDate:(long long)itDate;
// 计算 时分
+ (NSString *)getHour_MinuteByDate:(long long)itDate;

/**
 *  计算时间 年月日 返回XX.XX.XX
 *
 *  @param itDate
 *
 *  @return
 */
+ (NSString *)getYearMonthDayByDate:(long long)itDate;

@end
