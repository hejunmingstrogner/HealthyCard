//
//  LocationSearchModel.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "LocationSearchModel.h"

@implementation LocationSearchModel

+(instancetype)getInstance{
    static LocationSearchModel* sharedNetworkHttpManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedNetworkHttpManager = [[LocationSearchModel alloc] init];
    });
    return sharedNetworkHttpManager;
}

- (void)getExaminationAdressByLocation:(CLLocationCoordinate2D)Cllocation WithBlock:(ExaminationAddress)block
{
    if(block)
    {
        _examinationAddress = block;
    }
    _searcher = [[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = Cllocation;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(!flag)
    {
        if (_examinationAddress) {
            _examinationAddress(nil, [NSError errorWithDomain:@"网络连接错误" code:100 userInfo:[NSDictionary dictionaryWithObject:@"网络连接错误" forKey:@"error"]]);
        }
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      if (_examinationAddress) {
          _examinationAddress(result.address, nil);
      }
  }
  else {
      if (_examinationAddress) {
          _examinationAddress(nil, [NSError errorWithDomain:@"网络连接错误" code:100 userInfo:[NSDictionary dictionaryWithObject:@"网络连接错误" forKey:@"error"]]);
      }
  }
}
@end
