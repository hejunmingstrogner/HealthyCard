//
//  NSString+Count.h
//  GraduateDesign
//
//  Created by HighmoreXu on 15/11/25.
//  Copyright © 2015年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Count)

-(NSInteger)get256StingLength;
-(NSInteger)getShortStringLength;

+ (NSString *)getOldYears:(NSString *)idCard;   // 传入身份证号码计算年龄

@end
