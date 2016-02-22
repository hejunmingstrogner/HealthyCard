//
//  PositionUtil.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/20.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>
@interface PositionUtil : NSObject

/**
 *  将Gps坐标转换为百度坐标
 *
 *  @param gpscoor gps的坐标
 *
 *  @return 百度地图的坐标
 */
+ (CLLocationCoordinate2D) GPSLocationCoordinateToBaiduMapCoordinate:(CLLocationCoordinate2D)gpscoor;

- (CLLocationCoordinate2D)bd2wgs:(double)lat lon:(double)lon;
- (CLLocationCoordinate2D)wgs2bd:(double)lat lon:(double)lon;
@end
