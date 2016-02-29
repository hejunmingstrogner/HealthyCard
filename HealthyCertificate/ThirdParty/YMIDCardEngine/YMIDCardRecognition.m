//
//  YMIDCardRecognition.m
//  IDCardScanDemo
//
//  Created by lincan on 14-04-01.
//
//

#import "YMIDCardRecognition.h"

@implementation YMIDCardRecognition

-(id)initWithCard:(UIImage*)IDcardImg delegate:(id<YMIDCardRecognitionDelegate>)dge
{
    BKApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self=[super init])
    {
        self.delegate = dge;
        _BCREngine = [[YMIDCardEngine alloc] initWithLanguage:OCR_LAN_CHINESE];
        [_BCREngine setProgressCallbackDelegate:self];
        if (_BCREngine.initSuccess==YES)
        {
            [_BCREngine allocBImage:IDcardImg];
            
            [NSThread detachNewThreadSelector:@selector(BCRThread) toTarget:self withObject:nil];
            
        }
        else
        {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(recongnition:didFailWithError:)])
            {
                NSString *msg = NSLocalizedString(@"未授权或试用期已过!", nil);
                NSError *error = [NSError errorWithDomain:msg code:10 userInfo:nil];
                [self.delegate performSelector:@selector(recongnition:didFailWithError:) withObject:self withObject:error];
            }
        }
    }
    return self;
}

+(id)recongnitionWithCard:(UIImage*)IDcardImg delegate:(id<YMIDCardRecognitionDelegate>)delegate
{
    return [[[self alloc] initWithCard:IDcardImg delegate:delegate] autorelease];
}


- (void)BCRThread
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self.delegate setCancelProcess: NO];
	
	self.recogResultAry = [_BCREngine doBCR];
	if (![self.delegate getCancelProcess])
    {
		if (!self.recogResultAry)
        {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(recongnition:didFailWithError:)])
            {
                NSString *msg = NSLocalizedString(@"没有识别结果，请确认这是二代证", nil);
                NSError *error = [NSError errorWithDomain:msg code:11 userInfo:nil];
                [self.delegate performSelector:@selector(recongnition:didFailWithError:) withObject:self withObject:error];
            }
		}else
        {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(recongnition:didRecognitionResult:)])
            {
                [self.delegate performSelector:@selector(recongnition:didRecognitionResult:) withObject:self withObject:self.recogResultAry];
            }
        }
	}
	
	[pool release];
    
}


#pragma mark - callBack delegate
- (void)progressCallbackWithValue:(NSInteger)value
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(progressCallbackWithValue:)])
    {
        [self.delegate progressCallbackWithValue:value];
    }
}
- (void)progressStop
{
    
}

@end
