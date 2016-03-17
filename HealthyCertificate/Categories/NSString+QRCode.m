//
//  NSString+QRCode.m
//  QRCodeDemo
//
//  Created by Grey.Luo on 16/1/20.
//  Copyright © 2016年 Grey.Luo. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "NSString+QRCode.h"

@implementation NSString (QRCode)

- (UIImage *)qrcodeImageWithSize:(CGFloat)size{
    CIImage *qrCodeCIImage = [self createQrCodeCIImage];
    UIImage *qrCodeUIImage = [self createUIImageFromCIImage:qrCodeCIImage withSize:size];
    return qrCodeUIImage;
}

- (CIImage *)createQrCodeCIImage{
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

- (UIImage *)createUIImageFromCIImage:(CIImage *)image withSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);

    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
