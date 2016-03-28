//
//  RouteAnnotation.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/28.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
