//
//  BRContractTableFootCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/22.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BRContractTableFootCell.h"
#import <Masonry.h>
#import "UIFont+Custom.h"
#import "UILabel+FontColor.h"

@implementation BRContractTableFootCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:13];

    _orderedLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_orderedLabel];
    _orderedLabel.textAlignment = NSTextAlignmentRight;
    _orderedLabel.text = @"已预约:0";
    _orderedLabel.textColor = [UIColor grayColor];
    _orderedLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:13];
    [_orderedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_centerX).offset(-20);
        make.width.mas_equalTo(80);
    }];

    _checkedLabel = [[UILabel alloc]init];
    _checkedLabel.textAlignment = NSTextAlignmentRight;
    _checkedLabel.textColor = [UIColor grayColor];
    _checkedLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:13];
    _checkedLabel.text = @"已检查:0";
    [self.contentView addSubview:_checkedLabel];
    [_checkedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_orderedLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(_orderedLabel.mas_right).offset(10);
    }];
}

- (void)setCellItem:(BRContract *)brContract
{
    NSString *status = [BRContract getTestStatus:brContract.testStatus];    //  得到检查状态
    [self.textLabel setText:@"状态: " Font:[UIFont fontWithType:UIFontOpenSansRegular size:13] WithEndText:status endTextColor:[UIColor grayColor]];
    [_orderedLabel setText:@"已预约:" Font:[UIFont fontWithType:UIFontOpenSansRegular size:13] count:brContract.regCheckNum endColor:[UIColor blackColor]];
    [_checkedLabel setText:@"已检查" Font:[UIFont fontWithType:UIFontOpenSansRegular size:13] count:(brContract.factCheckNum <0 ? 0 : brContract.factCheckNum) endColor:[UIColor redColor]];
}
@end
