//
//  WorkTypeViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/1.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTypeViewController : UIViewController

typedef void(^WorkTypeBlock)(NSString* resultStr);

@property (nonatomic, copy) WorkTypeBlock block;

@end
