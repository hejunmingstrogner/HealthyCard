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
#import "ChargeParameter.h"

/**
 *  支付渠道
 */
typedef enum{
    PAY_NONE = 0,
    PAY_WX,         // 微信
    PAY_ALIPAY,     // 支付宝
    PAY_UPACP       // 银联
}PAYCHANNEL;

//http请求后，解析的数据格式的获取采用block的形式来获取
typedef void (^HCDictionaryResultBlock)(NSDictionary* result, NSError* error);
typedef void (^HCBoolResultBlock)(BOOL result, NSError* error);
typedef void (^HCArrayResultBlock)(NSArray* result, NSError* error);
typedef void (^HCImageResultBlock)(UIImage* image, NSError* error);

@interface HttpNetworkManager : NSObject

+(instancetype)getInstance;

+ (NSString *)baseURL;
//执行的http请求


/**
 *  检查版本更新
 */
-(void)checkVersionWithResultBlock:(HCBoolResultBlock)resultBlock;


#pragma mark - 登录相关
/**
 *  电话号码验证
 *
 *  @param phoneNum 电话号码
 */
-(void)verifyPhoneNumber:(NSString*)phoneNum resultBlock:(HCDictionaryResultBlock)resultBlock;


/**
 *  将得到的电话号码及输入的验证码发往服务端验证
 *
 *  @param phoneNum    电话号码
 *  @param code        验证码
 *  @param resultBlock 回调
 */
-(void)vertifyPhoneNumber:(NSString*)phoneNum VertifyCode:(NSString*)code resultBlock:(HCDictionaryResultBlock)resultBlock;


/**
 *  uuid登录
 *
 *  @param uuid        uuid
 *  @param uuidTimeout uuid 过期时间
 *  @param resultBlock 回调
 */
-(void)loginWithUuid:(NSString*)uuid UuidTimeOut:(NSString*)uuidTimeout resultBlock:(HCDictionaryResultBlock)resultBlock;


/**
 *  根据当前位置查询服务点信息
 *
 *  @param location 当前查询位置
 *  @param block    获得服务点信息之后的回调
 */
- (void)getNearbyServicePointsWithCLLocation:(CLLocationCoordinate2D)location resultBlock:(HCArrayResultBlock)resultBlock;


#pragma mark - 个人 单位信息相关
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
 *  查询合同相关的员工
 *
 *  @param contractCode 合同编号
 *  @param resultBlock  回调
 */
-(void)getCustomerListByBRContract:(NSString*)contractCode resultBlock:(HCArrayResultBlock)resultBlock;


/**
 *  查询单位下，未完成体检的员工
 *
 *  @param unitCode    单位编号
 *  @param resultBlock 回调
 */
-(void)getUnitsCustomersWithoutCheck:(NSString*) unitCode resultBlock:(HCArrayResultBlock)resultBlock;

/**
 *  获取合同关联的个人预约
 *
 *  @param contractCode 合同编号
 *  @param resultBlock  回调
 */
-(void)getCustomerTestListByContract:(NSString*)contractCode resultBlock:(HCArrayResultBlock)resultBlock;

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

#pragma mark - 取消个人预约
/**
 *  用于取消个人预约
 *
 *  @param checkCode 个人体检编号
 *  @param block     回调
 */
- (void)cancleCheckedCustomerTestWithCheckCode:(NSString *)checkCode resultBlock:(HCBoolResultBlock)block;


#pragma mark - 单位预约
/**
 *  单位预约
 *
 *  @param brcontract 预约封装的类
 *  @param employees  体检员工的列表
 *  @param block      回调
 */
- (void)createOrUpdateBRCoontract:(BRContract *)brcontract employees:(NSArray *)employees reslutBlock:(HCDictionaryResultBlock)block;

#pragma mark 根据名字模糊查询单位信息
/**
 *  根据名字模糊查询单位信息
 *
 *  @param companyName 要查询的名字
 *  @param block       回调 <BRServiceUnit>数组
 */
- (void)fuzzQueryBRServiceUnitsByName:(NSString *)companyName resultBlock:(HCArrayResultBlock)block;

#pragma mark - 查询个人历史
/**
 *  根据用户ID 查询获得个人历史 List<CustomerTest>
 *
 *  @param customId 用户ID
 *  @param block    回调
 */
- (void)findCustomerTestHistoryRegByCustomId:(NSString *)customId resuluBlock:(HCArrayResultBlock)block;

#pragma mark - 查询单位预约历史记录
/**
 *  根据id 查询获得单位预约历史记录 List<BRContract>
 *
 *  @param customId 单位code
 *  @param block    回调
 */
- (void)findBRContractHistoryRegByCustomId:(NSString *)customId resuleBlock:(HCArrayResultBlock)block;


#pragma mark - 支付相关
/**
 *  付款  提供付款金额，付款渠道 （金额 以保留到两位小数 如 11.56元,2.00元）
 *
 *  @param amount  金额  以保留到两位小数 如 11.56元，整数也同样两位 2.00元
 *  @param channel 渠道  wx  alipay upacp
 *  @param block   回调，如果没有error，则表示没有问题，resule提示支付结果
 */
- (void)payMoneyWithChargeParameter:(ChargeParameter *)chargeParame viewController:(UIViewController *)_self resultBlock:(void(^)(NSString *result, NSError *error))block;

/**
 *  获得城市中客户体检的价格
 *
 *  @param cityName  城市名
 *  @param checktype 体检类型 - 健康证体检
 *  @param block     返回价格 或者错误信息
 */
- (void)getCustomerTestChargePriceWithCityName:(NSString *)cityName checkType:(NSString *)checktype resultBlcok:(void(^)(NSString *result, NSError *error))block;

#pragma mark - 二维码
/**
 *  get二维码图片
 *
 *  @param content   二维码内容
 *  @param type      二维码类型
 *  @param edgeLength 二维码图片的边长度
 *  @param resultBlock 得到图片后的回调
 */
-(void)getQRImageByGet:(NSString*)content Type:(NSString*) type EdgeLength:(NSInteger)edgeLength resultBlock:(HCImageResultBlock)resultBlock;

@end
