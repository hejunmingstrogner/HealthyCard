//
//  CloudAppointmentViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServersPositionAnnotionsModel.h"
#import "CustomerTest.h"

@interface CloudAppointmentViewController : UIViewController

@property (nonatomic, copy) NSString* location;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, copy) NSString* appointmentDateStr;
@property (nonatomic, copy) NSString* cityName;

@property (nonatomic, strong) ServersPositionAnnotionsModel *sercersPositionInfo;

//判断是自己选择一个服务点进行预约 还是在一个已有的服务点上进行预约
@property (nonatomic, assign) BOOL isCustomerServerPoint;


//通过身份证扫描后，获得的身份证信息
@property (nonatomic, copy) NSArray* idCardInfo;

//预约的时候，往服务端上传的客户体检信息
@property (nonatomic, strong) CustomerTest* customerTestInfo;

/**
 *  隐藏界面的键盘
 */
-(void)hideTheKeyBoard;

@end
