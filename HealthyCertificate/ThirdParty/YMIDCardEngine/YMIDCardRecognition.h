//
//  YMIDCardRecognition.h
//  IDCardScanDemo
//
//  Created by wuzaifeng on 14-3-3.
//
//
@protocol YMIDCardRecognitionDelegate;
#import <Foundation/Foundation.h>
#import "YMIDCardEngine.h"
#import "AppDelegate.h"

@interface YMIDCardRecognition : NSObject<BCRProgressCallBackDelegate>
{
    YMIDCardEngine               *_BCREngine;
    BOOL                    progressCanceled;
    UIActionSheet           *progressSheet;
    UIProgressView          *progressBar;
    NSInteger               progressValue;
    AppDelegate           *BKApp;
}

@property (assign, nonatomic) id<YMIDCardRecognitionDelegate> delegate;

@property (retain, nonatomic)  NSArray *recogResultAry;
//IDcardImg为所需识别的二代证图片，dge为代理，即需要显示识别结果的UI界面
-(id)initWithCard:(UIImage*)IDcardImg delegate:(id<YMIDCardRecognitionDelegate>)dge;

+(id)recongnitionWithCard:(UIImage*)IDcardImg delegate:(id<YMIDCardRecognitionDelegate>)delegate;

@end






@protocol YMIDCardRecognitionDelegate <NSObject>
@required
//识别成功结果
- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didRecognitionResult:(NSArray *)array;

@optional
//识别失败
- (void)recongnition:(YMIDCardRecognition *)YMIDCardRecognition didFailWithError:(NSError *)error;
//UI界面更新进度条
-(void)progressCallbackWithValue:(NSInteger)value;
- (void)setCancelProcess:(BOOL)isCance;
- (BOOL)getCancelProcess;
@end