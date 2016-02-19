//
//  NavView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NavViewDelegate <NSObject>

-(void)backBtnClicked;
-(void)sureBtnClicked;

@end


@interface NavView : UIView

@property (nonatomic, strong) NSString* navTitle;
@property (nonatomic, weak) id<NavViewDelegate> delegate;

@end
