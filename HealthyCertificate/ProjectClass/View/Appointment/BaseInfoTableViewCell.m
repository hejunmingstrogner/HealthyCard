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
}

@end


@implementation BaseInfoTableViewCell


#pragma mark - Life Circle
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
    }
    return self;
}

#pragma mark - setter & getter
-(void)setIconName:(NSString *)iconName{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    [self addSubview:imageView];
    
    self.textView = [[UITextView alloc] init];
    self.textView.textColor = [UIColor blackColor];
    //self.textView.backgroundColor = [UIColor greenColor];
    self.textView.font = [UIFont fontWithType:UIFontOpenSansRegular size:FIT_FONTSIZE(Cell_Font)];
    [self addSubview:self.textView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).with.offset(10);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).with.offset(10);
        make.right.mas_equalTo(self).with.offset(-10);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(FIT_HEIGHT(50));
    }];
    
    }

-(void)setTextViewText:(NSString *)textViewText{
    self.textView.text = textViewText;
    [self.textView sizeToFit];
    CGSize size = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.textView.frame), FIT_HEIGHT(100))];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([NSNumber numberWithFloat:size.height]);
    }];
    
    [self setNeedsLayout];
}

@end
