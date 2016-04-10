//
//  PCheckAllPayView.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/10.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCheckAllPayViewDelegate <NSObject>
/**
 *  去批量支付
 */
- (void)payAll;

/**
 *  全选
 */
- (void)selectAll;

/**
 *  全不选
 */
- (void)deSelectAll;
@end

/**
 *  个人体检未完成待处理项中，显示全选，合计费用，以及批量支付的界面
 */
@interface PCheckAllPayView : UIView

@property (nonatomic, strong) id<PCheckAllPayViewDelegate>delegate;

@property (nonatomic, assign) NSInteger allCount;   // 需要支付的总人数
/**
 *  需要付款项
 */
@property (nonatomic, assign) float money;  // 单价

@property (nonatomic, assign) NSInteger count;  // 数量


- (instancetype)init;

//- (instancetype)initWithFrame:(CGRect)frame;

- (void)setMoney:(float)money count:(NSInteger)count;
@end
