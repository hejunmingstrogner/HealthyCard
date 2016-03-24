//
//  AddWorkerCellItem.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NOTSELECT = 0,          // 没有选中
    SELECT                  // 选中
}SelectFlag;

@interface AddWorkerCellItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) long long endDate;
@property (nonatomic, assign) SelectFlag isSelectFlag;

- (instancetype)initWithName:(NSString *)name phone:(NSString *)phone endDate:(long long)endDate selectFlag:(SelectFlag)isSelectFlag;

@end
