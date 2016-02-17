//
//  NSDictionary+NonNullStringValue.m
//  SioEyeAPP
//
//  Created by P22289D2 on 15/9/23.
//  Copyright (c) 2015年 CDCKT. All rights reserved.
//

#import "NSDictionary+NonNullStringValue.h"

@implementation NSDictionary (NonNullStringValue)

- (id)hikeNonNullValueForKey:(id)key{
    id value = [self valueForKey:key];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
@end
