//
//  DetailImageView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/24.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailImageView : UIView

-(instancetype)initWithImage:(UIImage*)image TotalCount:(NSString*)totalCount MonthCount:(NSString*)monthCount Frame:(CGRect)frame;

@end
