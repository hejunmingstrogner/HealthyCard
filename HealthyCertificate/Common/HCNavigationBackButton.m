//
//  HCNavigationBackButton.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/4.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HCNavigationBackButton.h"


#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

@implementation HCNavigationBackButton

#define kNaviBarBackButtonTextFontSize 17
#define kNaviBarBackButtonTextColor 0x000000

#define kNaviBarBackButtonTextLeftMargin 5

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        [self setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"back"] forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont fontWithType:UIFontOpenSansSemibold size:kNaviBarBackButtonTextFontSize];
        [self setTitleColor:[UIColor colorWithRGBHex:kNaviBarBackButtonTextColor] forState:UIControlStateNormal];
        [self setTitle:text forState:UIControlStateNormal];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, kNaviBarBackButtonTextLeftMargin, 0, -kNaviBarBackButtonTextLeftMargin);
        
        [self sizeToFit];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [self setTitle:text forState:UIControlStateNormal];
    
    [self sizeToFit];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 0.2;
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0;
    
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0;
    
    [super touchesEnded:touches withEvent:event];
}

@end
