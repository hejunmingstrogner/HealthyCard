//
//  NSString+QRCode.h
//  QRCodeDemo
//
//  Created by Grey.Luo on 16/1/20.
//  Copyright © 2016年 Grey.Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (QRCode)
- (UIImage *)qrcodeImageWithSize:(CGFloat)size;
@end
