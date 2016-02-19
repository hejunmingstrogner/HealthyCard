//
//  UserinformationSetingViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserinformationCellItem.h"

@interface UserinformationSetingViewController : UIViewController

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) NSString *cacheFlag;          // 需要缓存的标志

@property (nonatomic, assign) UserinformCellItemType itemtype;

@end
