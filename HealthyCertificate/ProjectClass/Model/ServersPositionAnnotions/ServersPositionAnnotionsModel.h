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
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface MyPointeAnnotation : BMKPointAnnotation
@property (nonatomic, assign) NSInteger tag;                    // 用于判断当前点击的是哪一个标注
@end


@interface BROutCheckArrange : NSObject

@property (nonatomic, strong) NSString * hosCode;              // 机构编号。
@property (nonatomic, strong) NSDate   * checkDate;             // 外检日期。
@property (nonatomic, strong) NSString * driverID;              // 驾驶人 ID。
@property (nonatomic, strong) NSString * driverName;            // 驾驶人姓名。
@property (nonatomic, strong) NSString * driverPhone;           // 驾驶人电话。
@property (nonatomic, strong) NSString * leaderName;            // 负责人姓名。
@property (nonatomic, strong) NSString * leaderPhone;           // 负责人电话。
@property (nonatomic, strong) NSString * memberList;            // 随行医生护士列表。
@property (nonatomic, strong) NSString * scount;                //
@property (nonatomic, strong) NSString * uid;                   // UID
@property (nonatomic, strong) NSString * vehicleID;             // 车辆ID
@property (nonatomic, strong) NSString * vehicleNO;             // 车辆牌照。
@property (nonatomic, strong) NSString * vehicleType;           // 车辆类型。
@end



@interface ServersPositionAnnotionsModel : NSObject

@property (nonatomic, strong) NSString * address;           // 服务点地址。
@property (nonatomic, strong) NSString * cHostCode;         // 所属机构ID。
@property (nonatomic, assign) int        checkinNum;        // 已检人数。
@property (nonatomic, assign) double     distance;          // 和查询位置的距离。 [单位：米]
@property (nonatomic, strong) NSDate   * endTime;           // 服务结束时间。
@property (nonatomic, strong) NSString * id;                // 服务点ID。 若为固定的，则是医疗机构编号；若为临时，则为临时服务点uid;
@property (nonatomic, strong) NSString * leaderPhone;       // 负责人电话。
@property (nonatomic, strong) NSString * name;              // 服务点名称。
@property (nonatomic, assign) int        oppointmentNum;    // 预约人数。
@property (nonatomic, assign) double     positionLa;        // 服务点纬度。
@property (nonatomic, assign) double     positionLo;        // 服务点经度。
@property (nonatomic, strong) NSDate   * startTime;         // 服务开始时间
@property (nonatomic, assign) int        type;              // 0固定服务点；1移动服务点。
@property (nonatomic, strong) BROutCheckArrange *brOutCheckArrange; // 外出服务安排。

@end
