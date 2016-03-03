//
//  EditInfoViewController.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/27.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EDITINFOTYPE)
{
    //姓名
    EDITINFO_NAME,
    //身份证号
    EDITINFO_IDCARD,
    // 电话号码
    EDITINFO_LINKPHONE
};

@interface EditInfoViewController : UIViewController

typedef void(^EditInfoBlock)(NSString* resultStr);

@property (nonatomic, assign) EDITINFOTYPE editInfoType;

-(void)setEditInfoText:(NSString*)text WithBlock:(EditInfoBlock)block;

@end
