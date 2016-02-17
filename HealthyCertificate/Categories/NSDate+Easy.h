//
//  NSDate+Easy.h
//  ByIM
//
//  Created by whrttv.com on 13-7-2.
//  Copyright (c) 2013年 whrttv.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Easy)

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)weekday;

- (BOOL)isToday;
- (BOOL)isYesterday;

- (NSDate *)yesteray;
- (NSDate *)tomorrow;

- (NSDate *)firstDayOfTWeek;
- (NSDate *)lastDayOfWeek;

- (NSDate *)firstDayOfNextWeek;
- (NSDate *)lastDayOfNextWeek;

- (NSDate *)firstDayOfPreviousWeek;
- (NSDate *)lastDayOfPreviousWeek;

- (NSDate *)firstDayOfMonth;
- (NSDate *)lastDayOfMonth;

- (NSDate *)firstDayOfNextMonth;
- (NSDate *)lastDayOfNextMonth;

- (NSDate *)firstDayOfPreviousMonth;
- (NSDate *)lastDayOfPreviousMonth;

- (NSDate *)nextWeek;
- (NSDate *)previousWeek;

- (NSDate *)nextMonth;
- (NSDate *)previousMonth;


- (NSString *)stringWithFormat:(NSString *)format locale:(NSLocale *)locale;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSDateComponents *)dateComponents; 
- (BOOL)isSameDay:(NSDate *)date;
- (NSDate *)dateWithoutTime;


@end
