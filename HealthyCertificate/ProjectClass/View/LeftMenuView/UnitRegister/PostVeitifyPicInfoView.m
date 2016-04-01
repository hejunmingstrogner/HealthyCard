//
//  PostVeitifyPicInfoView.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/31.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PostVeitifyPicInfoView.h"

#import <Masonry.h>

#import "Constants.h"

#import "UIFont+Custom.h"
#import "UILabel+Easy.h"

@implementation PostVeitifyPicInfoView
{
    UILabel     *_titleLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [UILabel labelWithText:_title font:[UIFont fontWithType:UIFontOpenSansRegular
                                                                         size:FIT_FONTSIZE(26)]
                                   textColor:[UIColor blackColor]];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(5);
        }];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.cornerRadius = 5;
        _imageView.backgroundColor = MO_RGBCOLOR(222, 223, 224);
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(5);
            make.right.bottom.equalTo(self).with.offset(-5);
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(5);
        }];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
        [_imageView addGestureRecognizer:singleTap];
    }
    return self;
}

#pragma mark - Setter & Getter
-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}


#pragma mark - Action
- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    if (_postVeitifyPicInfoViewBlock){
        _postVeitifyPicInfoViewBlock();
    }
}

@end
