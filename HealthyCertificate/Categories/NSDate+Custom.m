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
// 计算时间 XX.XX.XX
+ (NSString *)getYearMonthDayByDate:(long long)itDate
{
    if (!itDate) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:itDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

// 计算时间 XX年XX月XX日
+ (NSString *)getYear_Month_DayByDate:(long long)itDate
{
    if (!itDate) {
        return @"";
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:itDate];
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
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:itDate];
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

+ (NSDate*)formatDateFromChineseString:(NSString*)dateStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    return [format dateFromString:dateStr];
}

+(NSDate*)formatDateFromChineseStringWithHour:(NSString*)dateStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日,HH:00"];
    return [format dateFromString:dateStr];
}

-(long long)convertToLongLong
{
    return (long long)[self timeIntervalSince1970];
}

+(NSString*)converLongLongToChineseStringDate:(long long)dateLong
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:dateLong];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSString*)converLongLongToChineseStringDateWithHour:(long long)dateLong{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:dateLong];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日,HH:00"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSDateComponents*)getInternalDateFrom:(NSDate *)beginDate To:(NSDate *)endDate
{
    NSCalendar* chineseCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitDay;
    NSDateComponents *cps = [chineseCalender components:unitFlags fromDate:beginDate  toDate:endDate  options:0];
    return cps;
}

-(NSDate*)nextYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:1];
    NSDate *nextYear = [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
    return nextYear;
}

-(NSString*)getHour{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    return [dateFormatter stringFromDate:self];
}

@end
