//
//  CompanyItemListCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/11.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "CompanyItemListCell.h"

#import <Masonry.h>

#import "UIFont+Custom.h"

#import "Constants.h"

@interface CompanyItemListCell()
{
    UILabel*            _titleLabel;
}

@end


@implementation CompanyItemListCell

#define Cell_Font FIT_FONTSIZE(23)

#pragma mark - Life Circle
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Font];
        [self addSubview:_titleLabel];
        
        self.textView = [[UITextView alloc] init];
        self.textView.textColor = [UIColor blackColor];
        self.textView.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Font];
        [self addSubview:self.textView];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).with.offset(10);
        }];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).with.offset(10);
            make.right.mas_equalTo(self).with.offset(-10);
            make.height.mas_equalTo(FIT_HEIGHT(50));
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}


#pragma mark - Setter & Getter
-(void)setItemType:(CompanyItemListTextViewType)itemType
{
    switch (itemType) {
        case CDA_EXAMADDRESS:
        {
            _titleLabel.text = @"体检地址";
        }
            break;
        case CDA_EXAMTIME:
        {
            _titleLabel.text = @"体检时间";
        }
            break;
        case CDA_APPOINTMENTADDRESS:
        {
            _titleLabel.text = @"预约地址";
        }
            break;
        case CDA_APPOINTMENTTIME:
        {
            _titleLabel.text = @"预约时间";
        }
            break;
        default:
            break;
    }
}

#pragma mark - Public Methods
-(void)setTextViewText:(NSString *)textViewText
{
    self.textView.text = textViewText;
    [self.textView sizeToFit];
    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.frame.size.width - _titleLabel.frame.size.width - 30, CGFLOAT_MAX)];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([NSNumber numberWithFloat:(size.height<FIT_HEIGHT(50)?size.height:FIT_HEIGHT(50))]);
        // make.centerY.mas_equalTo(self);
    }];
    
    [self setNeedsLayout];
}
@end
