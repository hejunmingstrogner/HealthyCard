//
//  BRContractTableHeaerCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRContract.h"

@interface BRContractTableHeaerCell : UITableViewCell

@property (nonatomic, strong) UILabel *UnitNameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *addressLabel;

- (void)setCellItem:(BRContract *)brContract;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
