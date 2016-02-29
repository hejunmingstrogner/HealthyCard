//
//  OCREngine.h
//  IDCardScanDemo
//
//  Created by  on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Common.h"


@protocol BCRProgressCallBackDelegate;
@interface YMIDCardEngine : NSObject
{
    BEngine         *_bcrEngine;
    BImage          *_bImage;
    
    CGRect          textRect;
    
    NSInteger       progress;
}

@property (nonatomic, assign) NSInteger ocrLanguage;
@property (nonatomic, readonly) NSInteger codePage;
@property (nonatomic) BOOL     initSuccess;


- (id)initWithLanguage:(NSInteger)language;

- (BOOL)allocBImage:(UIImage*)image;
- (void)freeBImage;
- (BOOL)rotateBImage;
- (BOOL)blurDetection;

- (void)freeBField:(BField*)field;
- (void)displayBField:(BField*)field;

- (CGRect)charDetection:(CGPoint)firstPoint lastPoint:(CGPoint)lastPoint;
- (NSString*)doOCR;
- (NSArray*)doBCR;
- (BOOL)resetEngine:(NSInteger)language;

- (void)setProgressCallbackDelegate:(id<BCRProgressCallBackDelegate>)delegate;
- (void)progressCancel;
- (BOOL)isChinese:(NSString*)text;

@end

@protocol BCRProgressCallBackDelegate <NSObject>

- (void)progressCallbackWithValue:(NSInteger)value;
- (void)progressStop;

@end
