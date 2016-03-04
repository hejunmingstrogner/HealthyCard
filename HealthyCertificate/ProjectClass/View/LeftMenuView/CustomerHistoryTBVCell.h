//
//  CustomerHistoryTBVCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/3.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerTest.h"
#import "RzAlertView.h"
@interface CustomerHistoryTBVCell : UITableViewCell

@property (nonatomic, strong) CustomerTest *customerTest;
@property (nonatomic, strong) CustomButton    *reportBtn;

- (void)setCustomerTest:(CustomerTest *)customerTest;

@end
