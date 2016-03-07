//
//  BRContractHistoryTBHeaderCell.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/5.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRContract.h"
@interface BRContractHistoryTBHeaderCell : UITableViewCell

@property (nonatomic, strong) BRContract *brContract;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


- (void)setBrContract:(BRContract *)brContract;

@end
