//
//  ServersPositionAnnotionsModel.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServersPositionAnnotionsModel.h"

@implementation MyPointeAnnotation

@end

@implementation BROutCheckArrange


@end

@interface ServersPositionAnnotionsModel ()<BMKMapViewDelegate>

@end


@implementation ServersPositionAnnotionsModel

+(instancetype)getInstance{
    static ServersPositionAnnotionsModel* sharedNetworkHttpManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedNetworkHttpManager = [[ServersPositionAnnotionsModel alloc] init];
    });
    return sharedNetworkHttpManager;
}

- (void)addServersPositionAnnotionsWithList:(NSArray *)positions toMap:(BMKMapView *)mapView withSelectIndexBlock:(selectAnnotionIndex)block
{
    _selectAnnotionTag = block;
    mapView.delegate = self;
    int i = 0;
    for (ServersPositionAnnotionsModel *service in positions) {
        MyPointeAnnotation *annotion = [[MyPointeAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = service.positionLa;
        coor.longitude = service.positionLo;
        annotion.coordinate = coor;
        annotion.title = service.address;
        annotion.tag = i;
        [mapView addAnnotation:annotion];
        i++;
    }
}

#pragma mark - 重写annotionview delegate
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
//{
//
//    return nil;
//}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    MyPointeAnnotation *anno = view.annotation;
    if (_selectAnnotionTag) {
        _selectAnnotionTag(anno.tag);
    }
}
@end
