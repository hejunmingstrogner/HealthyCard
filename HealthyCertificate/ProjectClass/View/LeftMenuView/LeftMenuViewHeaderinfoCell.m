//
//  LeftMenuViewHeaderinfoCell.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/29.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "LeftMenuViewHeaderinfoCell.h"
#import <Masonry.h>
#import "UIFont+Custom.h"
#import <UIImageView+WebCache.h>
#import "HttpNetworkManager.h"

@interface LeftMenuViewHeaderinfoCell ()
@property (nonatomic, strong) UIImageView *headerimageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detialeLabel;
@end

@implementation LeftMenuViewHeaderinfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _headerimageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 60, 60)];
    [self.contentView addSubview:_headerimageView];
    _headerimageView.layer.masksToBounds = YES;
    _headerimageView.layer.cornerRadius = 30;

    _titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerimageView.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    _detialeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_detialeLabel];
    [_detialeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY);
        make.left.right.equalTo(_titleLabel);
        make.bottom.equalTo(self.contentView);
    }];
    _detialeLabel.font = [UIFont fontWithType:0 size:15];
}

- (void)setLeftMenuCellItem:(LeftMenuCellItem *)leftMenuCellItem
{
    _titleLabel.text = leftMenuCellItem.titleLabelText;
    _detialeLabel.text = leftMenuCellItem.detialLabelText;
    [_headerimageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@customer/getPhoto?cCustCode=%@", [HttpNetworkManager baseURL], gPersonInfo.mCustCode]] placeholderImage:[UIImage imageNamed:leftMenuCellItem.iconName] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
}
@end
