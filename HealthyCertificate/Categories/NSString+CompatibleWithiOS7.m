//
//  NSString+CompatibleWithiOS7.m
//  SioEyeAPP
//
//  Created by P22289D2 on 15/11/5.
//  Copyright © 2015年 CDCKT. All rights reserved.
//

#import "NSString+CompatibleWithiOS7.h"

@implementation NSString (CompatibleWithiOS7)

- (BOOL)hi_containsString:(NSString *)string{
    NSRange range = [self rangeOfString:string options:NSCaseInsensitiveSearch];
    return range.length != 0;
}
- (BOOL)hi_localizedCaseInsensitiveContainsString:(NSString *)string{
    return [self hi_containsString:string];
}
@end
