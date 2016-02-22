//
//  UserInformationController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserinformationSetingViewController.h"
#import "Constants.h"
#import "NSString+Count.h"
#import <UIButton+WebCache.h>

@interface UserInformationController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
