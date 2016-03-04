//
//  TakePhoto.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "TakePhoto.h"
#import "RzAlertView.h"
#import "MLImageCrop.h"

@interface TakePhoto()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MLImageCropDelegate>

@end

@implementation TakePhoto

#pragma mark - Public Methods
+(instancetype)getInstancetype{
    static TakePhoto* takephoto = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        takephoto = [[TakePhoto alloc] init];
        takephoto.ratio = -1;
    });
    return takephoto;
}

- (void)takePhotoFromCurrentController:(id)controller resultBlock:(resultImageBlock)block
{
    _ratio = -1;
    [RzAlertView showAlertViewControllerWithTarget:controller Title:@"请选择" Message:nil preferredStyle:UIAlertControllerStyleActionSheet ActionTitlesArray:@[@"立即拍照", @"本地图片"] handle:^(NSInteger flag) {
        if(flag != 0){
            _controller = controller;
            _block = block;
            if (flag == 1) {
                // 立即拍照
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [controller presentViewController:picker animated:YES completion:nil];
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:controller Title:@"提示" Message:@"无法使用相机，请重试" ActionTitle:@"明白了" ActionStyle:2];
                }
            }
            else {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [controller presentViewController:picker animated:YES completion:nil];
                }
                else
                {
                   [RzAlertView showAlertViewControllerWithTarget:controller Title:@"提示" Message:@"相册开启失败，请重试" ActionTitle:@"明白了" ActionStyle:2];
                }
            }
        }
    }];
}

- (void)takePhotoFromCurrentController:(id)controller WithRatioOfWidthAndHeight:(CGFloat)ratio resultBlock:(resultImageBlock)block
{
    if (ratio < 0) {
        [RzAlertView showAlertViewControllerWithTarget:controller Title:@"警告" Message:@"⚠️ 您的宽高比例设置错误" ActionTitle:@"确认" ActionStyle:UIAlertActionStyleDestructive];
        _ratio = -1;
        return;
    }
    _ratio = ratio;
    [RzAlertView showAlertViewControllerWithTarget:controller Title:@"请选择" Message:nil preferredStyle:UIAlertControllerStyleActionSheet ActionTitlesArray:@[@"立即拍照", @"本地图片"] handle:^(NSInteger flag) {
        if(flag != 0){
            _controller = controller;
            _block = block;
            if (flag == 1) {
                // 立即拍照
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [controller presentViewController:picker animated:YES completion:nil];
                }
                else{
                    [RzAlertView showAlertViewControllerWithTarget:controller Title:@"提示" Message:@"无法使用相机，请重试" ActionTitle:@"明白了" ActionStyle:2];
                }
            }
            else {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [controller presentViewController:picker animated:YES completion:nil];
                }
                else
                {
                    [RzAlertView showAlertViewControllerWithTarget:controller Title:@"提示" Message:@"相册开启失败，请重试" ActionTitle:@"明白了" ActionStyle:2];
                }
            }
        }
    }];
}
// 照片选择完毕
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

        image = [self fixOrientation:image];

        [picker dismissViewControllerAnimated:YES completion:nil];
        _photoimage = image;
        if (_ratio < 0) {
            if (_block) {
                _block(_photoimage);
            }
        }
        // 有设置宽高比例的，则进行裁剪
        else {
            MLImageCrop *imageCrop = [[MLImageCrop alloc]initWithRatioOfWidthAndHeight:_ratio];
            imageCrop.delegate = self;
            imageCrop.image = _photoimage;
            [imageCrop showWithAnimation:YES];
        }
    }
}

#pragma mark - crop delegate 裁剪之后的回调
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    CGFloat width = 0;
    CGFloat hight = 0;
    if (_ratio > 1) {
        width = self.view.bounds.size.width * 0.8;
        hight = width/_ratio;
    }
    else {
        hight = self.view.bounds.size.height * 0.8;
        width = hight * _ratio;
    }
    cropImage = [TakePhoto scaleImage:cropImage withSize:CGSizeMake(width, hight)]; // 压缩图片
    if (_block) {
        _block(cropImage);
    }
}
// 缩放图片
+(UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark -修正获取原图的时候自动旋转90的问题
- (UIImage *)fixOrientation:(UIImage *)aImage {

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;  
    }  
    
    // And now we just create a new UIImage from the drawing context  
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);  
    UIImage *img = [UIImage imageWithCGImage:cgimg];  
    CGContextRelease(ctx);  
    CGImageRelease(cgimg);  
    return img;  
}
@end
