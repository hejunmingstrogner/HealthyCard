//
//  CloudAppointmentCompanyViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServersPositionAnnotionsModel.h"
#import "BRContract.h"

@interface CloudAppointmentCompanyViewController : UIViewController

@property (nonatomic, copy) NSString* location;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;

@property (nonatomic, copy) NSString* appointmentDateStr;

@property (nonatomic, strong) ServersPositionAnnotionsModel *sercersPositionInfo;

//判断是自己选择一个服务点进行预约 还是在一个已有的服务点上进行预约
@property (nonatomic, assign) BOOL isCustomerServerPoint;

@property (nonatomic, strong) NSString   *cityName;

@property (nonatomic, strong) BRContract *brContract;   // 预约信息

/**
 *  隐藏界面的键盘
 */
-(void)hideTheKeyBoard;


typedef void(^resultBlock)(BOOL ischanged, NSIndexPath *indexpath); // 回调是否修改了数据
@property (nonatomic, assign) NSIndexPath *indexPath;               // 当前数据的indexpath
@property (nonatomic, strong) resultBlock resultblock;              // 回调
- (void)changedInformationWithResultBlock:(resultBlock)blcok;       // 修改了数据则需要刷新的回调

@end
