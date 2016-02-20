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
    NSInteger boardYear = [[idCard substringWithRange:NSMakeRange(6, 4)] integerValue];
    NSDateFormatter *datefammert = [[NSDateFormatter alloc]init];
    [datefammert setDateFormat:@"yyyy"];
    NSInteger currentyYear = [[datefammert stringFromDate:[NSDate date]] integerValue];
    return [NSString stringWithFormat:@"%d", currentyYear - boardYear];
}

@end
