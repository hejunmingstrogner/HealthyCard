//
//  ServicePointApointmentViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicePointApointmentViewController : UIViewController

@property (nonatomic, copy) NSArray* serverPointList;

/**
 *  隐藏界面的键盘
 */
-(void)hideTheKeyBoard;

@end
