//
//  CompanyAppointmentListViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/11.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRContract.h"

@interface CompanyAppointmentListViewController : UIViewController

@property (nonatomic, strong) BRContract* brContract;


typedef void(^resultBlock)(BOOL ischanged, NSIndexPath *indexpath); // 回调是否修改了数据
@property (nonatomic, assign) NSIndexPath *indexPath;               // 当前数据的indexpath
@property (nonatomic, strong) resultBlock resultblock;              // 回调
- (void)changedInformationWithResultBlock:(resultBlock)blcok;       // 修改了数据则需要刷新的回调

@end
