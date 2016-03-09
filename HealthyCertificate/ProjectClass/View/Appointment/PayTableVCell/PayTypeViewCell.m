//
//  PayTypeViewCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PayTypeViewCell.h"
#import <Masonry.h>
#import "Constants.h"

@interface PayTypeViewCell()

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel     *bgLabel;
@end

@implementation PayTypeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _bgLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_bgLabel];
        _bgLabel.layer.borderWidth = 1;
        [_bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(-1, 0, -1, 1));
        }];

        _selectImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_selectImageView];
        [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-PXFIT_WIDTH(24));
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(40);
        }];
    }
    return self;
}

- (void)setFlag:(NSInteger)flag
{
    if (flag != 1) {
        _selectImageView.image = [UIImage imageNamed:@"kongbai"];
        _bgLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else {
        _selectImageView.image = [UIImage imageNamed:@"selectstatus"];
        _bgLabel.layer.borderColor = [UIColor colorWithRed:1 green:155/255.0 blue:17/255.0 alpha:1].CGColor;
    }
    _flag = flag;
}

@end
