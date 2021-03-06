//
//  BaseTBCellItem.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "BaseTBCellItem.h"

@implementation BaseTBCellItem

- (instancetype)initWithTitle:(NSString *)title detial:(NSString *)detial
{
    if (self = [super init]) {
        _titleText = title;
        _detialText = detial;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title detial:(NSString *)detial cellStyle:(CELL_STYLE)cellstyle
{
    if (self = [super init]) {
        _titleText = title;
        _detialText = detial;
        _cellStyle = cellstyle;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detial:(NSString *)detial cellStyle:(CELL_STYLE)cellstyle
{
    if (self = [super init]) {
        _image = image;
        _titleText = title;
        _detialText = detial;
        _cellStyle = cellstyle;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detial:(NSString *)detial detial2:(NSString *)detialText_2 cellStyle:(CELL_STYLE)cellstyle
{
    if (self = [super init]) {
        _image = image;
        _titleText = title;
        _detialText = detial;
        _cellStyle = cellstyle;
        _detialText_2 = detialText_2;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detial:(NSString *)detial detial2:(NSString *)detialText_2 cellStyle:(CELL_STYLE)cellstyle flag:(NSInteger)flag
{
    if (self = [super init]) {
        _image = image;
        _titleText = title;
        _detialText = detial;
        _cellStyle = cellstyle;
        _detialText_2 = detialText_2;
        _flag = flag;
    }
    return self;
}


- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detial:(NSString *)detial cellStyle:(CELL_STYLE)cellstyle flag:(NSInteger)flag
{
    if (self = [super init]) {
        _image = image;
        _titleText = title;
        _detialText = detial;
        _cellStyle = cellstyle;
        _flag = flag;
    }
    return self;
}
@end
