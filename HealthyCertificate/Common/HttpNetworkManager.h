//
//  HttpNetworkManager.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PersonInfoOfPhonePacket.h"
#import "CompanyInfoOfPhonePacket.h"
#import "CustomerTest.h"
#import "BRContract.h"
#import "Constants.h"

//http请求后，解析的数据格式的获取采用block的形式来获取
typedef void (^HCDictionaryResultBlock)(NSDictionary* result, NSError* error);
typedef void (^HCBoolResultBlock)(BOOL result, NSError* error);
typedef void (^HCArrayResultBlock)(NSArray* result, NSError* error);

@interface HttpNetworkManager : NSObject

+(instancetype)getInstance;

+ (NSString *)baseURL;
//执行的http请求

/**
 *  电话号码验证
 *
 *  @param phoneNum 电话号码
 */
-(void)verifyPhoneNumber:(NSString*)phoneNum resultBlock:(HCDictionaryResultBlock)resultBlock;


/**
 *  根据当前位置查询服务点信息
 *
 *  @param location 当前查询位置
 *  @param block    获得服务点信息之后的回调
 */
- (void)getNearbyServicePointsWithCLLocation:(CLLocationCoordinate2D)location resultBlock:(HCArrayResultBlock)resultBlock;


/**
 *  更新或修改个人信息
 *
 *  @param personinfo 创建或更新用户信息
 *  @param block      返回的回调
 */
- (void)createOrUpdateUserinformationwithInfor:(NSDictionary *)personinfo resultBlock:(void(^)(BOOL successed, NSError *error))block;

/**
 *  更新或修改单位信息
 *
 *  @param BRServiceInfo 单位信息
 *  @param block         回调
 */
- (void)createOrUpdateBRServiceInformationwithInfor:(NSDictionary *)BRServiceInfo resultBlock:(void (^)(BOOL successed, NSError *error))block;

/**
 *  获得待处理项数据 － 预约数据（个人，单位数据）
 *
 *  @param block 回调
 */
- (void)getCheckListWithBlock:(void(^)(NSArray *customerArray, NSArray *brContractArray, NSError *error))block;

/**
 *  个人用户上传客户头像
 *
 *  @param photo 照片
 *  @param block 回调
 */
- (void)customerUploadPhoto:(UIImage *)photo resultBlock:(HCBoolResultBlock)block;

#pragma mark - 查询信息员工
/**
 *  查询单位所属的员工列表
 *
 *  @param cUnitCode 单位编号
 *  @param block     回调
 */
- (void)getWorkerCustomerDataWithcUnitCode:(NSString *)cUnitCode resultBlock:(HCArrayResultBlock)resultBlock;


/**
 *  查询行业类型列表
 *
 *  @param dataItemName eg: 健康证行业
 *  @param resultBlock  回调
 */
- (void)getIndustryList:(NSString*)dataItemName resultBlock:(HCArrayResultBlock)resultBlock;


#pragma mark - 个人预约
/**
 *  个人预约 登记或修改
 *
 *  @param customerTest 个人体检信息 mCheckCode为空代表登录，否则代表修改
 *  @param resultBlock  回调
 */
-(void)createOrUpdatePersonalAppointment:(CustomerTest*)customerTest resultBlock:(HCDictionaryResultBlock)resultBlock;

/**
 *  自主上传健康证的图片
 *
 *  @param photo       修改的图片
 *  @param checkCode   客户编号
 *  @param resultBlock 修改图片成功或失败后的回调
 */
-(void)customerUploadHealthyCertifyPhoto:(UIImage*)photo CusCheckCode:(NSString*)checkCode resultBlock:(HCDictionaryResultBlock)resultBlock;


#pragma mark - 单位预约
/**
 *  单位预约
 *
 *  @param brcontract 预约封装的类
 *  @param employees  体检员工的列表
 *  @param block      回调
 */
- (void)createOrUpdateBRCoontract:(BRContract *)brcontract employees:(NSArray *)employees reslutBlock:(HCBoolResultBlock)block;

#pragma mark 根据名字模糊查询单位信息
/**
 *  根据名字模糊查询单位信息
 *
 *  @param companyName 要查询的名字
 *  @param block       回调 <BRServiceUnit>数组
 */
- (void)fuzzQueryBRServiceUnitsByName:(NSString *)companyName resultBlock:(HCArrayResultBlock)block;
@end
