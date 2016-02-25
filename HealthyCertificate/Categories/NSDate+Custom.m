//
//  NSDate+Custom.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/20.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

- (NSMutableArray*)nextServerDays:(NSInteger)serverDays;
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    
    for (NSInteger index = 0; index < serverDays; ++index){
        NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([self timeIntervalSinceReferenceDate] + 24*3600*index)];
        NSString* dateStr = [format stringFromDate:newDate];
        [array addObject:dateStr];
    }
    return array;
}

// 计算时间 年月日
+ (NSString *)getYear_Month_DayByDate:(long long)itDate
{
    if (!itDate) {
        return @"";
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:itDate/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

// 计算时间 时分
+ (NSString *)getHour_MinuteByDate:(long long)itDate
{
    if (!itDate) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:itDate/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

- (NSString* )formatDateToChineseString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:self];
    return dateString;
}


- (NSDate* )getDateWithInternel:(NSInteger)interval
{
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([self timeIntervalSinceReferenceDate] + 24*3600*interval)];
    return newDate;
}

- (NSString* )getDateStringWithInternel:(NSInteger)interval
{
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([self timeIntervalSinceReferenceDate] + 24*3600*interval)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:newDate];
    return dateString;
}

@end
