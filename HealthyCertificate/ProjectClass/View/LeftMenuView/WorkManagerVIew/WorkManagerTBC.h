//
//  WorkManagerTBC.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"
/**
 *  员工管理界面cell的model
 */

typedef NS_ENUM(NSInteger, WorkManagerCellType) {
    WORKMANAGERCELL_NONE,
};

@interface WorkManagerTBCItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *telPhoneNo;
@property (nonatomic, assign) WorkManagerCellType type;
@property (nonatomic, strong) Customer *customer;
- (instancetype)initWithName:(NSString *)name sex:(NSString *)sex tel:(NSString *)telPhoneNo Type:(WorkManagerCellType)type Customer:(Customer *)customer;

@end



/**
 员工管理界面的tablview cell

 - returns:
 */
@interface WorkManagerTBC : UITableViewCell

@property (nonatomic, strong) WorkManagerTBCItem *cellItem;
@property (nonatomic, strong) UILabel *sexLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCellItem:(WorkManagerTBCItem *)cellItem;
@end
