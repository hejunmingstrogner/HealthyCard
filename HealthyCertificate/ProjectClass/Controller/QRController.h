//
//  QRController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/9.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRController : UIViewController

@property (nonatomic, copy) NSString* qrContent; //跳转的网页地址
@property (nonatomic, copy) NSString* shareText; //分享的内容
@property (nonatomic, copy) NSString* infoStr;   //二维码下面显示的文字

@end
