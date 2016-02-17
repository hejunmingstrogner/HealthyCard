//
//  UITextField+HIUserSignIn.m
//  SioEyeAPP
//
//  Created by P22289D2 on 15/9/15.
//  Copyright (c) 2015年 CDCKT. All rights reserved.
//

#import "HITextField+convenient.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"

#define hiTextFieldLeftGap 5
@implementation HITextField (convenient)

+ (HITextField *)hiTextFieldWithPlaceHolder:(NSString *)placeHolder{
    HITextField *field = [[HITextField alloc] init];
    UIColor *placeHolderColor = [UIColor colorWithRGBHex:hiPlaceHolderColor];
    UIFont *placeHolderFont = [UIFont fontWithType:UIFontOpenSansRegular size:17];
    field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeHolder
                                                                 attributes:@{NSForegroundColorAttributeName:placeHolderColor,
                                                                                         NSFontAttributeName:placeHolderFont
                                                                              }];
    return field;
}

+ (HITextField *)hiTextFieldWithLeftImage:(UIImage *)image placeHolder:(NSString *)placeHolder{
    HITextField *field = [self hiTextFieldWithPlaceHolder:placeHolder];
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:image];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.leftView = leftImage;
    return field;
}

+ (HITextField *)hiTextFieldWithLeftImage:(UIImage *)image
                            leftHighlight:(UIImage *)leftHighlight
                              placeHolder:(NSString *)placeHolder{
    HITextField *field = [self hiTextFieldWithLeftImage:image placeHolder:placeHolder];
    [(UIImageView *)field.leftView setHighlightedImage:leftHighlight];
    return field;
}
@end
