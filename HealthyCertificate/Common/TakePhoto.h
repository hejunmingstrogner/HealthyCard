//
//  TakePhoto.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhoto : UIViewController

@property (nonatomic, strong) id  controller;
@property (nonatomic, strong) UIImage *photoimage;
@property (nonatomic, assign) CGFloat ratio;        // 宽 ／ 高 比例

+ (instancetype)getInstancetype;
typedef void(^resultImageBlock)(UIImage *photoimage);
@property (nonatomic, strong) resultImageBlock block;
/**
 *  调用拍照的方法，不进行裁剪
 *
 *  @param controller 当前显示的controller
 *  @param allows     是否需要编辑照片
 *                    回调返回的是照片
 */
- (void)takePhotoFromCurrentController:(id)controller resultBlock:(resultImageBlock)block;

/**
 *  调用拍照的方法 并进行裁剪
 *
 *  @param controller 当前显示的controller （传入 “self”）
 *  @param ratio      宽高比例   ratio= 宽／高;
 *  @param block      回调裁剪后的图片
 */
- (void)takePhotoFromCurrentController:(id)controller WithRatioOfWidthAndHeight:(CGFloat)ratio resultBlock:(resultImageBlock)block;

// 缩放图片
+(UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size;

@end
