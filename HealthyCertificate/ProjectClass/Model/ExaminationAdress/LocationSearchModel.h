//
//  LocationSearchModel.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKSuggestionSearch.h>

@interface LocationSearchModel : NSObject <BMKGeoCodeSearchDelegate, BMKSuggestionSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *searcher;       // 地址编码

typedef void(^ExaminationAddress)(NSString *city, NSString *adress, NSError *error);

@property (nonatomic, strong)ExaminationAddress examinationAddress;

@property (nonatomic, strong) BMKSuggestionSearch *sugSearcher;     // 搜索建议

+(instancetype)getInstance;
/**
 *  根据坐标，反地址编码得到具体体检地址
 *
 *  @param Cllocation 坐标
 *  @param block      得到地址之后的回调
 */
- (void)getExaminationAdressByLocation:(CLLocationCoordinate2D)Cllocation WithBlock:(ExaminationAddress)block;

// 回调，返回城市数组，区数组，地址数组，坐标数组
typedef void(^SelectAddress)(NSArray *cityArray , NSArray *districtArray, NSArray *addressArray, NSArray *coordinateArray,NSError *error);

@property (nonatomic, strong) SelectAddress selectaddressblock;
/**
 *  根据关键字查询地址
 *
 *  @param text  关键字
 *  @param block 回调
 */
- (void)getLocationsWithKeyText:(NSString *)text withBlock:(SelectAddress)block;

@end
