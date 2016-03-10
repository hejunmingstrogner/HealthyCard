//
//  CustomerPositionLogPacket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BasePacket.h"

@interface CustomerPositionLogPacket : BasePacket

@property (nonatomic, assign) int m_nUID; // 主键
@property (nonatomic, copy) NSString *m_strCustCode; // 客户编号
@property (nonatomic, copy) NSString *m_strLinkPhone; // 电话号码
@property (nonatomic, copy) NSString * m_strPositionLO;		//定位经度
@property (nonatomic, copy) NSString * m_strPositionLA;		//定位纬度
@property (nonatomic, copy) NSString * m_strPositionDirection;	//定位方向
@property (nonatomic, copy) NSString* m_strPositionAddr; // 定位地址
@property (nonatomic, strong) NSDate* m_tAtTheTime; // 定位时间
@property (nonatomic, copy) NSString* m_strCityName;// 定位城市

@end
