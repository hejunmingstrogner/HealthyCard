//
//  HCNavigationBackButton.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/4.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCNavigationBackButton : UIButton
{
    UILabel         *_textLabel;
}

- (id)initWithText:(NSString *)text;
- (void)setText:(NSString *)text;

@end
