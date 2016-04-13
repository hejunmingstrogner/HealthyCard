//
//  PersonalAppointmentVC.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PersonalAppointmentVC : UIViewController

@property (nonatomic, strong) NSMutableArray *outCheckServicePoint;
@property (nonatomic, strong) NSMutableArray *fixedServicePoint;

//单位云预约
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;


@end
