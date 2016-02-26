//
//  SelectAddressViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SelectAddressViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *cityArray;        // 城市列表
@property (nonatomic, strong) NSMutableArray *districtArray;    // 区列表
@property (nonatomic, strong) NSMutableArray *addressArray;     // 地址列表
@property (nonatomic, strong) NSMutableArray *coordinateArray;  // 坐标列表     // 数值为NSValue 使用时先转换为CLLocationcoordinate2D

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSString *addressStr;

typedef void(^getAddressAndCoordinate)(NSString *city, NSString *district, NSString *address, CLLocationCoordinate2D coor);
@property (nonatomic, strong)getAddressAndCoordinate block;

- (void)getAddressArrayWithBlock:(getAddressAndCoordinate)block;

@end
