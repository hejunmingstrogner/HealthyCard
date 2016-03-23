//
//  ServicePositionDetialCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServicePositionDetialCellItem : NSObject

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *detialText;
@property (nonatomic, assign) NSInteger flag;

- (instancetype)initWithTitle:(NSString *)title detialText:(NSString *)detial;

- (instancetype)initWithTitle:(NSString *)title detialText:(NSString *)detial flag:(NSInteger)flag;
@end
