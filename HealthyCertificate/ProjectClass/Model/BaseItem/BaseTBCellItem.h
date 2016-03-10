//
//  BaseTBCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum{
    STYLE_NONE = 0,
    STYLE_HEADERIMAGE,
    STYLE_HEATHYCINFO,
    STYLE_WXPAY,            // 微信支付
    STYLE_ALIPAY,           // 支付宝支付
    STYLE_UPACP             // 银联支付
}CELL_STYLE;

@interface BaseTBCellItem : NSObject
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *detialText;
@property (nonatomic, strong) NSString *detialText_2;
@property (nonatomic, assign) CELL_STYLE cellStyle;
@property (nonatomic, assign) NSInteger flag;

- (instancetype)initWithTitle:(NSString *)title detial:(NSString *)detial;

- (instancetype)initWithTitle:(NSString *)title detial:(NSString *)detial cellStyle:(CELL_STYLE)cellstyle;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detial:(NSString *)detial cellStyle:(CELL_STYLE)cellstyle;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detial:(NSString *)detial detial2:(NSString *)detialText_2 cellStyle:(CELL_STYLE)cellstyle;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detial:(NSString *)detial detial2:(NSString *)detialText_2 cellStyle:(CELL_STYLE)cellstyle flag:(NSInteger)flag;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detial:(NSString *)detial cellStyle:(CELL_STYLE)cellstyle flag:(NSInteger)flag;
@end
