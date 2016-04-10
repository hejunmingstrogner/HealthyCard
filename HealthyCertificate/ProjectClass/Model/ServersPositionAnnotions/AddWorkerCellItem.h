//
//  AddWorkerCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

typedef NS_ENUM(NSInteger, SelectFlag){
    NOTSELECT = 0,          // 没有选中
    SELECT                  // 选中
};

@interface AddWorkerCellItem : NSObject

@property (nonatomic, strong) Customer *customer;

@property (nonatomic, assign) SelectFlag isSelectFlag;

- (instancetype)initWithCustomer:(Customer *)customer selectFlag:(SelectFlag )flag;

@end
