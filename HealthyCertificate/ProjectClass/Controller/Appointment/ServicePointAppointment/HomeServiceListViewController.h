//
//  HomeServiceListViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@class ServersPositionAnnotionsModel;

@protocol HomeServiceListViewControllerDelegate<NSObject>

-(void)choosedServerPoint:(ServersPositionAnnotionsModel*)sp;

@end


@interface HomeServiceListViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;

@property (nonatomic, weak) id<HomeServiceListViewControllerDelegate> delegate;

@property (nonatomic, strong) ServersPositionAnnotionsModel  *selectedSpModel;

@end
