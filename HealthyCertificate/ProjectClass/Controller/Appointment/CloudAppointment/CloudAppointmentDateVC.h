//
//  CloudAppointmentDateVC.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudAppointmentDateVC : UIViewController

typedef void(^AppointmentDateStringBlock)(NSString *dateStr);

@property (nonatomic, strong) NSString* beginDateString;
@property (nonatomic, strong) NSString* endDateString;
@property (nonatomic, copy) AppointmentDateStringBlock appointmentBlock;

/**
 *  获得预约日期范围
 *
 *  @param block 获得预约日期范围后的回调
 */
-(void)getAppointDateStringWithBlock:(AppointmentDateStringBlock)block;

@end
