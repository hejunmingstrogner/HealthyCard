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

@class BROutCheckArrange;
@class OutCheckSite;
@class Employee;
#pragma mark - 服务点信息的 气泡 模型
/**
 *  服务点信息的 气泡 模型
 */
@interface MyPointeAnnotation : BMKPointAnnotation
@property (nonatomic, assign) NSInteger tag;                    // 用于判断当前点击的是哪一个标注
@end

#pragma mark - 移动服务点的信息
/**
 *  移动服务点的信息
 */
@interface OutCheckSitePartInfo : NSObject
/**
 * 0待生效 <br>
 * 10未开始<br>
 * 20已到达 <br>
 * 30停止预约。
 * 99 已失效
 */
@property (nonatomic, assign) int testStatus;

/**
 *  判断是否在固定服务点的详情界面显示head的标题信息
 *  如：xxxx.xx.xx之前召集16个小伙伴，此体检点生效！已召集 <chargedNum>
 *  还可以预约 50人   已预约 50人
 *  @return
 */
- (BOOL) isShowTitleInfoView;
/**
 *  获取移动服务点的testStatus的状态对应的文本
 *
 *  @return
 */
- (NSString *)getOutCheckSitePartInfoTestStatus;

/**
 *  获取移动服务点的testStatus的状态的文本对应的颜色
 *
 *  @return 颜色
 */
- (UIColor *)getOutCheckSitePartInfoTestStatusLabelColor;

/**
 * 服务点类型。
 * <ul>
 * <li>0：个人自建。</li>
 * <li>1：单位自建。</li>
 * <li>2：平台设定。</li>
 * </ul>
 */
@property (nonatomic, assign) Byte siteType;
/**
 * 外出安排ID。
 */
@property (nonatomic, strong) NSString * outCheckArrangeID;
/**
 * 预约人数。
 */
@property (nonatomic, assign) int        oppointmentNum;
/**
 * 已检人数。
 */
@property (nonatomic, assign) int        checkinNum;
/**
 * 最大允许人数。  =0 表示”无限制“
 */
@property (nonatomic, assign) int        maxNum;

/**
 * 已支付人数。
 */
@property (nonatomic, assign) int chargedNum;       // 召集的人数

/**
 * 外出服务安排。
 */
@property (nonatomic, strong) BROutCheckArrange* outcheckArrange;

@end


#pragma mark - 固定服务点的信息
@interface HosPartInfo : NSObject
/**
 * 从左到右共4位二进制（代出证，上门体检，到院体检，代化验）例如 8表示可带出证，12表示可代出证，可上门体检.
 */
@property (nonatomic, assign) int checkMode;

/**
 * 0：自建可办证； 1：合作机构；2：其它机构。3：自建可上门。
 */
@property (nonatomic, assign) int workType;

/**
 * 服务时间
 */
@property (nonatomic, strong) NSString * serviceTime;

@end


#pragma mark - 外出安排服务
/**
 *  外出安排服务 class
 */
@interface BROutCheckArrange : NSObject

@property (nonatomic, strong) NSString * hosCode;              // 机构编号。         //
@property (nonatomic, strong) NSDate   * checkDate;             // 外检日期。        //
@property (nonatomic, strong) NSString * driverID;              // 驾驶人 ID。
@property (nonatomic, strong) NSString * driverName;            // 驾驶人姓名。       //
@property (nonatomic, strong) NSString * driverPhone;           // 驾驶人电话。       //
@property (nonatomic, strong) NSString * driverCode;            // 司机编号          //
@property (nonatomic, strong) NSString * leaderName;            // 负责人姓名。       //
@property (nonatomic, strong) NSString * leaderPhone;           // 负责人电话。       //
@property (nonatomic, strong) NSString * memberList;            // 随行医生护士列表。  //
@property (nonatomic, strong) NSString * uid;                   // UID              //
@property (nonatomic, strong) NSString * vehicleID;             // 车辆ID
@property (nonatomic, strong) NSString * vehicleNO;             // 车辆牌照。
@property (nonatomic, strong) NSString * vehicleType;           // 车辆类型。
@property (nonatomic, strong) NSString * plateNo;               // 车牌号           //
@property (nonatomic, strong) NSString * vheicleCode;           // 车辆编号         //
@property (nonatomic, strong) NSString * vehicleInfo;           // 车辆信息         //
@property (nonatomic, assign) int        scount;                //

@property (nonatomic, strong) NSMutableArray<OutCheckSite *> *outCheckSites;
@property (nonatomic, strong) NSMutableArray<Employee *> *members;
/**
 * 组长Name
 */
@property (nonatomic, strong) NSString *captainName;

/**
 * 外检小组ID。
 */
@property (nonatomic, strong) NSString *teamUID;
/**
 * 外检小组名。
 */
@property (nonatomic, strong) NSString *teamName;

/**
 * 此次出车安排已检人数 【非数据库字段】
 */
@property (nonatomic, assign) int checkinNum;

@end


#pragma mark - 服务点信息基本类
/**
 *  服务点信息类
 */
@interface ServersPositionAnnotionsModel : NSObject

@property (nonatomic, assign) int TYPE_OUTCHECK;            // 临时服务点   ＝ 1
@property (nonatomic, assign) int TYPE_HOS;                 // 固定服务点   ＝ 0
@property (nonatomic, strong) NSString * address;           // 服务点地址。
@property (nonatomic, copy)   NSString * hosCode;           // 所属机构ID
@property (nonatomic, assign) int        checkinNum;        // 已检人数。
@property (nonatomic, assign) double     distance;          // 和查询位置的距离。 [单位：千米]
@property (nonatomic, assign) long long  endTime;           // 服务结束时间。
@property (nonatomic, strong) NSString * id;                // 服务点ID。 若为固定的，则是医疗机构编号；若为临时，则为临时服务点uid;
@property (nonatomic, strong) NSString * leaderPhone;       // 负责人电话。
@property (nonatomic, strong) NSString * name;              // 服务点名称。
@property (nonatomic, assign) int        oppointmentNum;    // 预约人数。
@property (nonatomic, assign) double     positionLa;        // 服务点纬度。
@property (nonatomic, assign) double     positionLo;        // 服务点经度。
@property (nonatomic, assign) long long  startTime;         // 服务开始时间
@property (nonatomic, assign) int        type;              // 0固定服务点；1移动服务点。
@property (nonatomic, strong) BROutCheckArrange *brOutCheckArrange; // 外出服务安排。
@property (nonatomic, assign) int        innerType;         //若为固定服务点，0：自建可办证； 1：合作机构；2：其它机构。3：自建可上门。
@property (nonatomic, assign) int        checkMode;         //从左到右共4位二进制（代出证，上门体检，到院体检，代化验）例如  8表示可带出证，12表示可代出证，可上门体检.
@property (nonatomic, assign) int        maxNum;            //最大允许预约人数
/**
 * @derecated {@link HosPartInfo#serviceTime}
 */
@property (nonatomic, strong) NSString * serviceTime;


/**
 * 移动服务点的独立信息。 若type为{@link ServicePoint#TYPE_OUTCHECK} 时，该值不为空。
 */
@property (nonatomic, strong) OutCheckSitePartInfo *outCheckSitePartInfo;

/**
 * 固定服务点的独立信息。 。 若type为{@link ServicePoint#TYPE_HOS} 时，该值不为空。
 */
@property (nonatomic, strong)  HosPartInfo *hosPartInfo;


// 服务器待添加数据
@property (nonatomic, strong) NSString *introduce;      // 详情介绍
@property (nonatomic, strong) NSString *busWay;         // 路线地址
@property (nonatomic, strong) NSString *centerAddress;  // 中心地址


@end
