//
//  UIFont+Custom.m
//  SioEyeAPP
//
//  Created by Hu Yi on 15/10/19.
//  Copyright © 2015年 CDCKT. All rights reserved.
//

#import "UIFont+Custom.h"

@implementation UIFont (Custom)

+ (NSString *)fontNameForType:(UIFontCustomType)type
{
    NSString *name = nil;
    switch (type) {
        case UIFontOpenSansBold:
        {
            name = @"OpenSans-Bold";
            break;
        }
        case UIFontOpenSansSemibold:
        {
            name = @"OpenSans-Semibold";
            break;
        }
        case UIFontOpenSansRegular:
        default:
        {
            name = @"OpenSans";
            break;
        }
    }

    return name;
}

+ (UIFont *)fontWithType:(UIFontCustomType)type size:(CGFloat)size
{
    return [UIFont fontWithName:[UIFont fontNameForType:type] size:size];
}

@end
