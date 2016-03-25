//
//  ServicePointDetailViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServersPositionAnnotionsModel.h"
#import "HCBackgroundColorButton.h"

// 固定服务点
@interface ServicePointDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ServersPositionAnnotionsModel *serverPositionItem;

@property (nonatomic, assign) CLLocationCoordinate2D appointCoordinate;    // 预约坐标

@property (nonatomic, strong) HCBackgroundColorButton    *orderBtn; // 预约

@property (nonatomic, strong) NSMutableArray *inforArray;

@end
