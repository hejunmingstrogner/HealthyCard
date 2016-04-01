//
//  PostVeitifyPicInfoView.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/31.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PostVeitifyPicInfoView : UIView

//点击照片后的回调
typedef void(^PostVeitifyPicInfoViewBlock)();

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, strong) UIImage*  image;

@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, copy) PostVeitifyPicInfoViewBlock postVeitifyPicInfoViewBlock;

@end
