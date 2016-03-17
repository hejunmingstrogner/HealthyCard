//
//  BaseInfoTableViewCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/19.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BaseInfoTableViewCell.h"
#import <Masonry.h>

#import "UIFont+Custom.h"
#import "Constants.h"

#define Cell_Font 23

@interface BaseInfoTableViewCell()
{
    UIImageView* _imageView;
}
@end

@implementation BaseInfoTableViewCell

#pragma mark - Life Circle
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {}
    return self;
}

#pragma mark - setter & getter
-(void)setIconName:(NSString *)iconName{
    UIImage* iconImage = [UIImage imageNamed:iconName];
    _imageView = [[UIImageView alloc] initWithImage:iconImage];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    self.textView = [[UITextView alloc] init];
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    [self addSubview:self.textView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(iconImage.size.width);
        make.left.mas_equalTo(self).with.offset(10);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(_imageView.mas_right).with.offset(10);
        make.right.mas_equalTo(self).with.offset(-10);
        make.height.mas_equalTo(FIT_HEIGHT(50));
    }];
}

-(void)setTextViewText:(NSString *)textViewText{
    self.textView.text = textViewText;
    [self.textView sizeToFit];
    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.frame.size.width - _imageView.frame.size.width - 30, CGFLOAT_MAX)];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([NSNumber numberWithFloat:(size.height<FIT_HEIGHT(50)?size.height:FIT_HEIGHT(50))]);
    }];
    
    [self setNeedsLayout];
}

@end
