//
//  AddWorkerTBC.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, addworkerType){
    ADDWORKER_NAME,         // 姓名
    ADDWORKER_SEX,          // 性别
    ADDWORKER_AGE,          // 年龄
    ADDWORKER_IDCARD,       // 身份证号码
    ADDWORKER_TELPHONE,     // 电话号码
    ADDWORKER_CALLING,      // 行业
    ADDWORKER_UNIT          // 单位
};

@interface AddworkerTBCItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) addworkerType type;

- (instancetype)initWithTitle:(NSString *)title Message:(NSString *)message type:(addworkerType)type;
@end


@interface AddWorkerTBC : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

@end
