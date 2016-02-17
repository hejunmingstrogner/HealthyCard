//
//  UITextField+HIUserSignIn.h
//  SioEyeAPP
//
//  Created by P22289D2 on 15/9/15.
//  Copyright (c) 2015年 CDCKT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HITextField.h"

#define hiPlaceHolderColor 0xa3a3a3

@interface HITextField (convenient)


+ (HITextField *)hiTextFieldWithPlaceHolder:(NSString *)placeHolder;

//- (void)hiTextViewShowPassword:(BOOL)shouldShow;
+ (HITextField *)hiTextFieldWithLeftImage:(UIImage *)image placeHolder:(NSString *)placeHolder;

+ (HITextField *)hiTextFieldWithLeftImage:(UIImage *)image
                            leftHighlight:(UIImage *)leftHighlight
                              placeHolder:(NSString *)placeHolder;
@end
