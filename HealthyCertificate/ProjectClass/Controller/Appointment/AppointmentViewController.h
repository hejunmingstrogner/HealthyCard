//
//  AppointmentViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppointmentViewController : UIViewController

@property (nonatomic, copy) NSString* location;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) NSMutableArray* nearbyServicePointsArray;
@property (nonatomic, copy) NSString* cityName;

@end
