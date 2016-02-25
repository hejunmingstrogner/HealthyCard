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

// 计算时间 年月日
+ (NSString *)getYear_Month_DayByDate:(NSDate *)itDate;
// 计算 时分
+ (NSString *)getHour_MinuteByDate:(NSDate *)itDate;

@end
