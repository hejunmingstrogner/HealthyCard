//
//  UserinformationSetingViewController.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserinformationCellItem.h"
#import "RzAlertView.h"
#import "PersonInfoOfPhonePacket.h"
#import "CompanyInfoOfPhonePacket.h"
#import "Constants.h"
#import "HttpNetworkManager.h"
#import "HCRule.h"

@interface UserinformationSetingViewController : UIViewController

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) NSString *cacheFlag;          // 需要缓存的标志

@property (nonatomic, assign) UserinformCellItemType itemtype;

typedef void(^updateInfo)(BOOL successed, NSString *updataText);

// 更新成功之后的回调
@property (nonatomic, strong)updateInfo updateBlcok;
- (void)isUpdateInfoSucceed:(updateInfo) block;

@end
