//
//  CustomButton.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonActionBlock)(UIButton *);

@interface CustomButton : UIButton

@property(nonatomic,copy)ButtonActionBlock block;
- (void)addClickedBlock:(ButtonActionBlock)block;

@end
