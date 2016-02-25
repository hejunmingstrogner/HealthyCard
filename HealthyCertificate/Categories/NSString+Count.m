//
//  NSString+Count.m
//  GraduateDesign
//
//  Created by HighmoreXu on 15/11/25.
//  Copyright © 2015年 JIANGXU. All rights reserved.
//

#import "NSString+Count.h"

@implementation NSString(Count)

-(NSInteger)get256StingLength{
    return self.length + 1;
}

-(NSInteger)getShortStringLength{
    return self.length + 2;
}

+ (NSString *)getOldYears:(NSString *)idCard
{
    if ([idCard isEqualToString:@""]) {
        return @"暂无";
    }
    NSString *boardYear;   // 截取出生年月日
    // 15位
    if (idCard.length == 15) {
        boardYear = [NSString stringWithFormat:@"19%@",[idCard substringWithRange:NSMakeRange(6, 6)]];
    }
    else
    {
        boardYear = [idCard substringWithRange:NSMakeRange(6, 8)];
    }

    NSDateFormatter *datefammert = [[NSDateFormatter alloc]init];
    [datefammert setDateFormat:@"yyyy-MM-dd"];

    NSString *currentyear = [datefammert stringFromDate:[NSDate date]];

    // 获取年月日
    NSInteger year = [[boardYear substringWithRange:NSMakeRange(0, 4)] integerValue];
    NSInteger month = [[boardYear substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSInteger day = [[boardYear substringWithRange:NSMakeRange(6, 2)] integerValue];

    NSArray *currenttime = [currentyear componentsSeparatedByString:@"-"];
    NSInteger old = [currenttime[0] integerValue] - year;

    // 月小于当前月
    if (month < [currenttime[1] integerValue]) {
        return [NSString stringWithFormat:@"%d", old];
    }
    if (month > [currenttime[1] integerValue]) {
        return [NSString stringWithFormat:@"%d", old - 1];
    }
    if (day > [currenttime[2] integerValue]) {
        return [NSString stringWithFormat:@"%d", old - 1];
    }
    else {
        return [NSString stringWithFormat:@"%d", old];
    }
}

@end
