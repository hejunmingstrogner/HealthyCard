//
//  CloudAppointmentCompanyViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CloudAppointmentCompanyViewController : UIViewController

@property (nonatomic, copy) NSString* location;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;

@property (nonatomic, copy) NSString* appointmentDateStr;

/**
 *  隐藏界面的键盘
 */
-(void)hideTheKeyBoard;

@end
