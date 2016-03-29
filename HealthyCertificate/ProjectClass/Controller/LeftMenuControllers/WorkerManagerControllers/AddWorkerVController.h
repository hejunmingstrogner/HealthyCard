//
//  AddWorkerVController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddworkVControllerDelegate <NSObject>
// 添加员工成功
- (void)creatWorkerSucceed;

@end

@interface AddWorkerVController : UIViewController

@property(nonatomic, strong) id<AddworkVControllerDelegate> delegate;

@end
