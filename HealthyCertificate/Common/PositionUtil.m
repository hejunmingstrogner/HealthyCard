//
//  PositionUtil.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/20.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PositionUtil.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

// 定义一些常量
static double x_PI = 3.14159265358979324 * 3000.0 / 180.0;      // 圆周率转换量
static double PI = 3.1415926535897932384626;                    // 圆周率
static double a = 6378245.0;                                    // 卫星椭球坐标投影到平面地图坐标系的投影因子
static double ee = 0.00669342162296594323;                      // 椭球的偏心率

@interface PositionUtil()

@end

@implementation PositionUtil

// gps转换为百度坐标
+(CLLocationCoordinate2D)GPSLocationCoordinateToBaiduMapCoordinate:(CLLocationCoordinate2D)gpscoor
{
    NSDictionary *coordit = BMKConvertBaiduCoorFrom(gpscoor, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(coordit);
    return baiduCoor;
}

#pragma mark 百度转Gps

- (CLLocationCoordinate2D)wgs2gcj:(CLLocationCoordinate2D)wgsll
{
    CLLocationCoordinate2D coor = wgsll;

    if ([self outOfChina:wgsll.latitude lon:wgsll.longitude]) {
        return wgsll;
    }

    double dLat = [self transformLat:wgsll.longitude - 105.0 y:wgsll.latitude - 35.0];
    double dLon = [self transformLon:wgsll.longitude - 105.0 y: wgsll.latitude - 35.0];
    double radLat = wgsll.latitude / 180.0 * PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * PI);
    coor.latitude = wgsll.latitude + dLat;
    coor.longitude = wgsll.longitude + dLon;
    return coor;
}

- (CLLocationCoordinate2D)wgs2gcj:(double)lat lon:(double)lon{
    return [self wgs2gcj:CLLocationCoordinate2DMake(lat, lon)];
}

- (CLLocationCoordinate2D)gcj2wgs:(CLLocationCoordinate2D)gcjll
{
    if ([self outOfChina:gcjll.latitude lon:gcjll.longitude]) {
        return gcjll;
    }
    double dlat = [self transformLat:gcjll.longitude - 105.0 y:gcjll.latitude - 35.0];
    double dlng = [self transformLon:gcjll.longitude - 105.0 y:gcjll.latitude - 35.0];
    double radlat = gcjll.latitude / 180.0 * PI;
    double magic = sin(radlat);
    magic = 1 - ee * magic * magic;
    double sqrtmagic = sqrt(magic);
    dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * PI);
    dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * PI);
    double mglat = gcjll.latitude + dlat;
    double mglng = gcjll.longitude + dlng;
    return CLLocationCoordinate2DMake(gcjll.latitude * 2 - mglat, gcjll.longitude * 2 - mglng);
}

- (CLLocationCoordinate2D)gcj2wgs:(double)lat lon:(double)lon{
    return [self gcj2wgs:CLLocationCoordinate2DMake(lat, lon)];
}

- (CLLocationCoordinate2D)gcj2bd:(CLLocationCoordinate2D)gcjll
{
    double x = gcjll.longitude, y = gcjll.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_PI);
    double bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}

- (CLLocationCoordinate2D)gcj2bd:(double)lat lon:(double)lon{
    return [self gcj2bd:CLLocationCoordinate2DMake(lat, lon)];
}

- (CLLocationCoordinate2D)bd2gcj:(CLLocationCoordinate2D)bdll
{
    double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x = bdll.longitude - 0.0065, y = bdll.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}

- (CLLocationCoordinate2D)bd2gcj:(double)lat lon:(double)lon{
    return [self bd2gcj:CLLocationCoordinate2DMake(lat, lon)];
}
- (CLLocationCoordinate2D)bd2wgs:(CLLocationCoordinate2D)bdll
{
    CLLocationCoordinate2D gcj02 = [self bd2gcj:bdll];
    return [self gcj2wgs:gcj02];
}
- (CLLocationCoordinate2D)bd2wgs:(double)lat lon:(double)lon{
    return [self bd2gcj:CLLocationCoordinate2DMake(lat, lon)];
}
- (CLLocationCoordinate2D)wgs2bd:(CLLocationCoordinate2D)bdll
{
    CLLocationCoordinate2D gcj02 = [self wgs2gcj:bdll];
    return [self gcj2bd:gcj02];
}

- (CLLocationCoordinate2D)wgs2bd:(double)lat lon:(double)lon{
    return [self wgs2bd:CLLocationCoordinate2DMake(lat, lon)];
}

- (BOOL)outOfChina:(double)lat lon:(double)lon
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}
- (double)transformLat:(double)x y:(double)y
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * PI) + 20.0 * sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * PI) + 40.0 * sin(y / 3.0 * PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * PI) + 320 * sin(y * PI / 30.0)) * 2.0 / 3.0;
    return ret;
}
- (double)transformLon:(double)x y:(double)y
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * PI) + 20.0 * sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * PI) + 40.0 * sin(x / 3.0 * PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * PI) + 300.0 * sin(x / 30.0 * PI)) * 2.0 / 3.0;
    return ret;
}
@end
