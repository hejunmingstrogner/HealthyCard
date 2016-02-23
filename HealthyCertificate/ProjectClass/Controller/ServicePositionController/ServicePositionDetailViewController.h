//
//  ServicePositionDetailViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServersPositionAnnotionsModel.h"

// 移动服务点
@interface ServicePositionDetailViewController : UIViewController

@property (nonatomic, strong) ServersPositionAnnotionsModel *servicePositionItem;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton    *orderBtn; // 预约

@property (nonatomic, strong) NSMutableArray *detialeInfoArray;

@end
