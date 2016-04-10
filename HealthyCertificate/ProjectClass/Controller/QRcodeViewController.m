//
//  QRcodeViewController.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/3/30.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "QRcodeViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>

@interface QRcodeViewController()<AVCaptureMetadataOutputObjectsDelegate>
@end

@implementation QRcodeViewController
{
//    AVCaptureDevice             *_device;
//    AVCaptureDeviceInput        *_input;
//    AVCaptureMetadataOutput     *_output;
//    AVCaptureSession            *_session;
//    AVCaptureVideoPreviewLayer  *_preview;
    
    BOOL    _isReading;
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer* _videoPreviewLayer;
}

- (BOOL)startReading {
    _isReading = YES;
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
//    if (self.qrcodeFlag)
//        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
//    else
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeQRCode, nil]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (!_isReading) return;
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
//        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];

     //   Do Something....
    } 
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startReading];
    
//    CGRect test = self.view.frame;
//    
//    // Device
//    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    // Input
//    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
//    
//    // Output
//    _output = [[AVCaptureMetadataOutput alloc]init];
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    // Session
//    _session = [[AVCaptureSession alloc]init];
//    
//    [_session setSessionPreset:AVCaptureSessionPresetHigh];
//    if ([_session canAddInput:_input])
//    {
//        [_session addInput:_input];
//    }
//    if ([_session canAddOutput:_output])
//    {
//        [_session addOutput:_output];
//    }
//    
//    // 条码类型
//    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//    
//    // Preview
//    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
//    _preview.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
//    [self.view.layer addSublayer:_preview];
//    
//    // Start
//    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
//{
//    NSString *stringValue;
//    
//    if ([metadataObjects count] >0) {
//        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
//        stringValue = metadataObject.stringValue;
//    }
//    
//    [_session stopRunning];
//    
////    [self dismissViewControllerAnimated:YES completion:^{
////        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
////                                                      message:stringValue
////                                                     delegate:nil
////                                            cancelButtonTitle:@"OK"
////                                            otherButtonTitles:nil,nil];
////        [alert show];
////    }];
//}

@end
