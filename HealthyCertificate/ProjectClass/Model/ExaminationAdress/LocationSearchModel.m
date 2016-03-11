//
//  LocationSearchModel.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/16.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "LocationSearchModel.h"

@interface LocationSearchModel()
{
    //第一次获得地理位置信息
    BOOL                _isLocationFirstSet;
}

@end


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
            _examinationAddress(nil, nil, [NSError errorWithDomain:@"网络连接错误" code:100 userInfo:[NSDictionary dictionaryWithObject:@"网络连接错误" forKey:@"error"]]);
        }
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      if (_examinationAddress) {
          _examinationAddress(result.addressDetail.city,result.address, nil);
      }
  }
  else {
      if (_examinationAddress) {
          _examinationAddress(nil, nil, [NSError errorWithDomain:@"网络连接错误" code:100 userInfo:[NSDictionary dictionaryWithObject:@"网络连接错误" forKey:@"error"]]);
      }
  }
}

#pragma mark -正向地址编码
//
- (void)getLocationsWithKeyText:(NSString *)text withBlock:(SelectAddress)block
{
    _selectaddressblock = block;
    //初始化检索对象
    _sugSearcher =[[BMKSuggestionSearch alloc]init];
    _sugSearcher.delegate = self;
    BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
    option.cityname = @"";
    option.keyword  = text;
    BOOL flag = [_sugSearcher suggestionSearch:option];
    if(flag)
    {
        NSLog(@"建议检索发送成功");
    }
    else
    {
        NSLog(@"建议检索发送失败");
    }
}
//实现Delegate处理回调结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (_selectaddressblock) {
            _selectaddressblock(result.cityList, result.districtList,result.keyList, result.ptList, nil);
        }
    }
    else {
        if (_selectaddressblock) {
            _selectaddressblock(nil, nil, nil, nil, [NSError errorWithDomain:@"error" code:404 userInfo:[NSDictionary dictionaryWithObject:@"没有数据" forKey:@"error"]]);
        }
    }
}
@end
