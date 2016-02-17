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

@end
