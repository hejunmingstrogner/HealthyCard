//
//  NSDate+Easy.m
//  ByIM
//
//  Created by whrttv.com on 13-7-2.
//  Copyright (c) 2013年 whrttv.com. All rights reserved.
//

#import "NSDate+Easy.h"

@implementation NSDate (Easy)

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSYearCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    
    return dateComponents.year;
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSMonthCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    
    return dateComponents.month;
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    
    return dateComponents.day;

}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSHourCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    
    return dateComponents.hour;

}

- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSMinuteCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    
    return dateComponents.minute;

}

- (NSInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    
    return dateComponents.second;

}

- (NSInteger)weekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSWeekdayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    
    return dateComponents.weekday;

}

- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    NSDate *date = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *todayComponents = [calendar components:components fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:todayComponents];
    
    return [date isEqualToDate:today];
}

- (BOOL)isYesterday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    NSDate *date = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *todayComponents = [calendar components:components fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:todayComponents];
    NSDateComponents *minusComponents = [[NSDateComponents alloc] init];
    [minusComponents setDay:-1];
    NSDate *yesterday = [calendar dateByAddingComponents:minusComponents toDate:today options:0];
    
    return [date isEqualToDate:yesterday];
}

- (NSDate *)yesteray
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    
    NSDateComponents *todayComponents = [calendar components:components fromDate:self];
    NSDate *today = [calendar dateFromComponents:todayComponents];
    NSDateComponents *minusComponents = [[NSDateComponents alloc] init];
    [minusComponents setDay:-1];
    NSDate *yesterday = [calendar dateByAddingComponents:minusComponents toDate:today options:0];
    
    return yesterday;
}

- (NSDate *)tomorrow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;

    NSDateComponents *todayComponents = [calendar components:components fromDate:self];
    NSDate *today = [calendar dateFromComponents:todayComponents];
    NSDateComponents *minusComponents = [[NSDateComponents alloc] init];
    [minusComponents setDay:1];
    NSDate *tomorrow = [calendar dateByAddingComponents:minusComponents toDate:today options:0];
    
    return tomorrow;
}

- (NSString *)stringWithFormat:(NSString *)format locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:locale];
    
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    return [self stringWithFormat:format locale:[NSLocale currentLocale]];
}

- (NSDateComponents *)dateComponents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit
                |NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:components fromDate:self];
    return dateComponents;
}

- (BOOL)isSameDay:(NSDate *)date
{
    BOOL same = NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    NSDateComponents *dateComponents = [calendar components:components fromDate:date];
    if ( selfComponents.era == dateComponents.era && selfComponents.year == dateComponents.year
        && selfComponents.month == dateComponents.month && selfComponents.day == dateComponents.day )
    {
        same = YES;
    }
    
    return same;
}

- (NSDate *)firstDayOfTWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setWeekday:1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)lastDayOfWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setWeekday:7];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)firstDayOfNextWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setWeek:[selfComponents week] + 1];
    [selfComponents setWeekday:1];
    
    return [calendar dateFromComponents:selfComponents];
}
- (NSDate *)lastDayOfNextWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setWeek:[selfComponents week] + 1];
    [selfComponents setWeekday:7];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)firstDayOfPreviousWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setWeek:[selfComponents week] - 1];
    [selfComponents setWeekday:1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)lastDayOfPreviousWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setWeek:[selfComponents week] - 1];
    [selfComponents setWeekday:7];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)firstDayOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setDay:1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)lastDayOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setMonth:[selfComponents month] + 1];
    [selfComponents setDay:-1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)firstDayOfNextMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setMonth:[selfComponents month] + 1];
    [selfComponents setDay:1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)lastDayOfNextMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setMonth:[selfComponents month] + 2];
    [selfComponents setDay:-1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)firstDayOfPreviousMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setMonth:[selfComponents month] - 1];
    [selfComponents setDay:1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)lastDayOfPreviousMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setDay:-1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)nextWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setWeek:[selfComponents week] + 1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)previousWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setWeek:[selfComponents week] - 1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)nextMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setMonth:[selfComponents month] + 1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)previousMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *selfComponents = [calendar components:components fromDate:self];
    
    [selfComponents setMonth:[selfComponents month] - 1];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)dateWithoutTime
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}


@end
