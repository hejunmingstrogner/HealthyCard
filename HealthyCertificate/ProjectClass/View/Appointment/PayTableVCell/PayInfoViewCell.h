//
//  PayInfoViewCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInfoViewCell : UITableViewCell
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *payManName;
@property (nonatomic, strong) NSString *getManName;
@property (nonatomic, strong) NSString *money;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
