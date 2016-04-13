//
//  ServicePointApointmentViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ServicePointApointmentViewController : UIViewController

typedef NS_ENUM(NSInteger, ServicePointApointmentViewControllerType)
{
    ServicePointApointmentViewControllerType_Customer,
    ServicePointApointmentViewControllerType_Cloud
};

@property (nonatomic, copy) NSArray* serverPointList;

@property (nonatomic, assign) ServicePointApointmentViewControllerType serviceType;

//单位云预约
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;

@end
