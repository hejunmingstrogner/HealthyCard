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


// 计算时间 年月日
+ (NSString *)getYear_Month_DayByDate:(long long)itDate;
// 计算 时分
+ (NSString *)getHour_MinuteByDate:(long long)itDate;

@end
