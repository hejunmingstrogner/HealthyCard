//
//  ConsumerAgreement.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/18.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumerAgreement : UIViewController

typedef NS_ENUM (NSInteger, ConsumerPopStyle){
    ConsumerPopStyle_Pop,
    ConsumerPopStyle_DisMiss
};

@property (nonatomic, assign) ConsumerPopStyle consumerPopStyle;

@end
