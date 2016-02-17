//
//  LocationSearchModel.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
@interface LocationSearchModel : NSObject <BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *searcher;

typedef void(^ExaminationAddress)(NSString *adress, NSError *error);

@property (nonatomic, strong)ExaminationAddress examinationAddress;

+(instancetype)getInstance;
/**
 *  根据坐标，反地址编码得到具体体检地址
 *
 *  @param Cllocation 坐标
 *  @param block      得到地址之后的回调
 */
- (void)getExaminationAdressByLocation:(CLLocationCoordinate2D)Cllocation WithBlock:(ExaminationAddress)block;

@end
