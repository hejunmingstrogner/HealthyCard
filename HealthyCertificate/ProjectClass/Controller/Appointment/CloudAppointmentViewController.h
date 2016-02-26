//
//  CloudAppointmentViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServersPositionAnnotionsModel.h"

@interface CloudAppointmentViewController : UIViewController

@property (nonatomic, copy) NSString* location;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, copy) NSString* appointmentDateStr;

@property (nonatomic, strong) ServersPositionAnnotionsModel *sercersPositionInfo;

/**
 *  隐藏界面的键盘
 */
-(void)hideTheKeyBoard;

@end
