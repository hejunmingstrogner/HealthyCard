//
//  UIFont+Custom.h
//  SioEyeAPP
//
//  Created by Hu Yi on 15/10/19.
//  Copyright © 2015年 CDCKT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIFontOpenSansRegular = 0x1000,
    UIFontOpenSansBold,
    UIFontOpenSansSemibold
}UIFontCustomType;

@interface UIFont (Custom)

+ (UIFont *)fontWithType:(UIFontCustomType)type size:(CGFloat)size;

@end
