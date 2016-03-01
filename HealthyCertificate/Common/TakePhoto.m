//
//  TakePhoto.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/2/25.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "TakePhoto.h"
#import "RzAlertView.h"


@interface TakePhoto()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation TakePhoto

#pragma mark - Public Methods
+(instancetype)getInstancetype{
    static TakePhoto* takephoto = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        takephoto = [[TakePhoto alloc] init];
    });
    return takephoto;
}

- (void)takePhotoFromCurrentController:(id)controller resultBlock:(resultImageBlock)block
{

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
                    picker.allowsEditing = YES;
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
                    picker.allowsEditing = YES;
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
    NSData *imagedata;
    if([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

        if (UIImagePNGRepresentation(image) == nil) {
            imagedata = UIImageJPEGRepresentation(image, 1);
        }
        else {
            imagedata = UIImagePNGRepresentation(image);
        }
        UIImage *endimage = [UIImage imageWithData:imagedata];

        [picker dismissViewControllerAnimated:YES completion:nil];
        _photoimage = endimage;
        if (_block) {
            _block(_photoimage);
        }
    }
}
// 缩放图片
-(UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
