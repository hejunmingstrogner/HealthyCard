//
//  HCBackgroundColorButton.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/21.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HCBackgroundColorButton.h"

@interface HCBackgroundColorButton()

@property(nonatomic, strong) NSMutableDictionary* backgroundColors;

@end


@implementation HCBackgroundColorButton


#pragma mark - Public Methods
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    if (!self.backgroundColors) {
        self.backgroundColors = [[NSMutableDictionary alloc] init];
    }
    
    if (backgroundColor) {
        self.backgroundColors[@(state)] = backgroundColor;
    }
    
    if (state == UIControlStateNormal) {
        self.backgroundColor = backgroundColor;
    }
}


#pragma mark - Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UIColor *selectedColor = self.backgroundColors[@(UIControlStateHighlighted)];
    if (selectedColor) {
        [self transitionBackgroundToColor:selectedColor];
//        [NSThread sleepForTimeInterval:1.0f];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    UIColor *normalColor = self.backgroundColors[@(UIControlStateNormal)];
    if (normalColor) {
        [self transitionBackgroundToColor:normalColor];
//        [NSThread sleepForTimeInterval:1.0f];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UIColor *normalColor = self.backgroundColors[@(UIControlStateNormal)];
    if (normalColor) {
        [self transitionBackgroundToColor:normalColor];
//        [NSThread sleepForTimeInterval:1.0f];
    }
}

#pragma mark - Private Methods
- (void)transitionBackgroundToColor:(UIColor*)color {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:animation forKey:@"EaseOut"];
    self.backgroundColor = color;
}


@end
