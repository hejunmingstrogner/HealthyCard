//
//  NSString+Custom.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

+(NSString*)combineString:(NSString*)firstString And:(NSString*)secondString With:(NSString*)sepString
{
    NSMutableString* resultString = [[NSMutableString alloc] init];
    [resultString appendString:firstString];
    [resultString appendString:sepString];
    [resultString appendString:secondString];
    return resultString;
}

- (long long)getLongLongBornDate
{
    NSString* bornDateStr;
    
    if (self.length == 15){
        bornDateStr = [NSString stringWithFormat:@"19%@",[self substringWithRange:NSMakeRange(6, 6)]];
    }else{
        bornDateStr = [self substringWithRange:NSMakeRange(6, 8)];
    }
    
    bornDateStr = [NSString stringWithFormat:@"%@-%@-%@",[bornDateStr substringWithRange:NSMakeRange(0, 4)],
                   [bornDateStr substringWithRange:NSMakeRange(4, 2)],
                   [bornDateStr substringWithRange:NSMakeRange(6, 2)]];
    
    NSDateFormatter *datefammert = [[NSDateFormatter alloc]init];
    [datefammert setDateFormat:@"yyyy-MM-dd"];
    NSDate* resultDate = [datefammert dateFromString:bornDateStr];
    return (long long)[resultDate timeIntervalSince1970];
}

-(long long)convertDateStrToLongLong
{
    NSDateFormatter *datefammert = [[NSDateFormatter alloc]init];
    [datefammert setDateFormat:@"yyyy年MM月dd日"];
    NSDate* resultDate = [datefammert dateFromString:self];
    return (long long)[resultDate timeIntervalSince1970];
}


- (NSString *)deleteSpaceWithHeadAndFootWithString:(NSString *)text
{
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end

