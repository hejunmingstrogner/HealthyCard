//
//  BaseTBCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/7.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
  STYLE_NONE = 0,
}CELL_STYLE;

@interface BaseTBCellItem : NSObject
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *detialText;
@property (nonatomic, assign) CELL_STYLE cellStyle;

- (instancetype)initWithTitle:(NSString *)title detial:(NSString *)detial cellStyle:(CELL_STYLE)cellstyle;

@end
