//
//  IndexViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/15.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RzAlertView.h"

#import <Masonry.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

#import "LocationSearchModel.h"
#import "LeftMenuView.h"

@interface IndexViewController : UIViewController<BMKMapViewDelegate, BMKLocationServiceDelegate>
{
    UIButton    *headerBtn;                 // 头像按钮
    UILabel     *titleLabel;                // 标题
    UIButton    *pendingBtn;                // 待处理按钮
    UIButton    *minDistanceBtn;            // 最近服务点距离按钮

    BMKMapView  *_mapView;
    UIImageView *locateimageview;           // 显示要定位地点的标注图钉
    NSTimer     *changeStatusTimer;         // 拖拽地图时，定时器用于判断是否拖拽完成时，调用方法得到位置

    UILabel     *addressLabel;              // 地址label
    UIButton    *orderBtn;                  // 预约按钮

    BMKLocationService *_locationServer;    // 位置服务
    CLLocationManager  *_locationmanager;   // 位置管理

    LeftMenuView  *leftMenuView;            // 左侧菜单栏
}


@end
