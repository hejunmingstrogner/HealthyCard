//
//  ServersPositionAnnotionsModel.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>

@interface ServersPositionAnnotionsModel : NSObject<BMKMapViewDelegate>

+(instancetype)getInstance;

/**
 *  将服务点位置添加到地图上
 *
 *  @param positions 服务点数组
 *  @param mapView   添加到哪个地图上
 */
- (void)addServersPositionAnnotionsWithList:(NSArray *)positions toMap:(BMKMapView *)mapView;

@end
