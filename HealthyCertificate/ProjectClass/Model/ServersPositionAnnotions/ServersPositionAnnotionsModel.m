//
//  ServersPositionAnnotionsModel.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/17.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServersPositionAnnotionsModel.h"

@implementation MyPointeAnnotation

@end

@implementation OutCheckSitePartInfo

// 获取对应的状态的文本
- (NSString *)getOutCheckSitePartInfoTestStatus
{
    if (self.testStatus == 0) {
        return @"待\n生\n效";
    }

    if (!self.outCheckArrangeID) {
        return @"待\n安\n排";
    }

    if (self.testStatus == 10) {
        return @"待\n体\n检";
    }

    if (self.testStatus == 20) {
        return @"体\n检\n中";
    }

    if (self.testStatus == 30) {
        return @"已\n停\n止";
    }
    if (self.testStatus == 99) {
        return @"已\n失\n效";
    }
    return @"";
}

// 获取移动服务点的testStatus的状态的文本对应的颜色
- (UIColor *)getOutCheckSitePartInfoTestStatusLabelColor
{
    if (self.testStatus == 0) {
        return [UIColor orangeColor];   // 未生效
    }

    if (!self.outCheckArrangeID) {
        return [UIColor redColor];  // 待安排
    }

    if (self.testStatus == 10) {
        return [UIColor blueColor];  //待体检
    }

    if (self.testStatus == 20) {
        return [UIColor greenColor];  //体检中
    }

    if (self.testStatus == 30) {
        return [UIColor grayColor];  //已停止
    }

    if (self.testStatus == 99) {
        return [UIColor grayColor];  //已失效
    }
    return [UIColor clearColor];  //"";
}

/**
 *  判断是否在固定服务点的详情界面显示head的标题信息
 *  如：xxxx.xx.xx之前召集16个小伙伴，此体检点生效！已召集 <chargedNum>
 *  还可以预约 50人   已预约 50人
 *  @return
 */
- (BOOL) isShowTitleInfoView
{
    if (self.testStatus == 0) {
        return YES;
    }

    if (!self.outCheckArrangeID) {
        return YES;
    }

//    if (self.testStatus == 10) {
//        return @"待\n体\n检";
//    }
//
//    if (self.testStatus == 20) {
//        return @"体\n检\n中";
//    }
//
//    if (self.testStatus == 30) {
//        return @"已\n停\n止";
//    }
//    if (self.testStatus == 99) {
//        return @"已\n失\n效";
//    }
    return NO;
}

@end

@implementation HosPartInfo

@end

@implementation BROutCheckArrange


@end

@interface ServersPositionAnnotionsModel ()<BMKMapViewDelegate>

@end


@implementation ServersPositionAnnotionsModel


@end
