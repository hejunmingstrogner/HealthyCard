//
//  OutCheckSiteHeaderView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/4/13.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServersPositionAnnotionsModel;

@interface OutCheckSiteHeaderView : UIView

//还可预约人数
@property (nonatomic, assign) NSInteger countPeople;

//预约人数
@property (nonatomic, assign) NSInteger appointmentCount;


-(void)setServerPointInfo:(ServersPositionAnnotionsModel*)spModel;

@end
