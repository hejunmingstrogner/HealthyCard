//
//  TemperaryServicePDeViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServersPositionAnnotionsModel.h"

// 移动服务点
@interface TemperaryServicePDeViewController : UIViewController

@property (nonatomic, strong) UIButton    *orderBtn; // 预约

@property (nonatomic, strong) ServersPositionAnnotionsModel *servicePositionItem;


@end
