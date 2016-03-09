//
//  QRController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/9.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "QRController.h"

#import <ZXingObjCAztec.h>
#import <ZXMultiFormatWriter.h>
#import <Masonry.h>

@implementation QRController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:@"A string to encode"
                                  format:kBarcodeFormatQRCode
                                   width:300
                                  height:300
                                   error:&error];
    if (result) {
        UIImage* image = [UIImage imageWithCGImage: [ZXImage imageWithMatrix:result].cgimage];
        
        UIImageView* bckImageView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:bckImageView];
        [bckImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        
    } else {
        NSString *errorMessage = [error localizedDescription];
    }
    
    
}



@end
