//
//  ServersPositionAnnotionsModel.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServersPositionAnnotionsModel.h"

@implementation ServersPositionAnnotionsModel

+(instancetype)getInstance{
    static ServersPositionAnnotionsModel* sharedNetworkHttpManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedNetworkHttpManager = [[ServersPositionAnnotionsModel alloc] init];
    });
    return sharedNetworkHttpManager;
}

- (void)addServersPositionAnnotionsWithList:(NSArray *)positions toMap:(BMKMapView *)mapView
{
    mapView.delegate = self;

}

#pragma mark - 重写annotionview delegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{

    return nil;
}

@end
