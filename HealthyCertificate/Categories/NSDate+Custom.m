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

@end
