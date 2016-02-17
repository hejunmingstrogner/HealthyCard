//
//  RzAlertView.m
//  RzAlertViewController
//
//  Created by 乄若醉灬 on 16/1/29.
//  Copyright © 2016年 乄若醉灬. All rights reserved.
//

#import "RzAlertView.h"

@implementation RzAlertView
@synthesize titleLabel;
- (instancetype)init
{
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithSuperView:(UIView *)superView Title:(NSString *)title
{
    if (self = [self init]) {
        titleLabel.text = title;
        [superView addSubview:self];
        [superView bringSubviewToFront:self];
    }
    return self;
}

- (void)initSubViews
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    // 黑色背景遮罩
    backgroundView = [[UIView alloc]initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.5];
    [self addSubview:backgroundView];

    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
    alertView.center = backgroundView.center;
    alertView.backgroundColor = [UIColor colorWithRed:40/255.0 green:44/255.0 blue:50/255.0 alpha:0.7];
    [self addSubview:alertView];

    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 10;

    // 显示的提示文字
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 200, 45)];
    [alertView addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:17];

    // 旋转的菊花
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(alertView.bounds.size.width/2, alertView.bounds.size.height/2 + 5);
    [alertView addSubview:activityView];

    self.hidden = YES;
    backgroundView.alpha = 0;
    alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    titleLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    activityView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);

    isshowing = NO;
}

- (void)show
{
    if (isshowing) {
        return;
    }
    isshowing = YES;
    self.hidden = NO;
    [activityView startAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        backgroundView.alpha = 0.4;
        alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        titleLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        activityView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
}
- (void)close
{
    if (!isshowing) {
        return;
    }
    [activityView stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        backgroundView.alpha = 0;
        alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
        titleLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
        activityView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.01, 0.01);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        isshowing = NO;
    });
}

- (void)removeAlertView
{
    [activityView removeFromSuperview];
    [titleLabel removeFromSuperview];
    [alertView removeFromSuperview];
    [backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

// 显示两个按钮的alertview
+ (void)showAlertViewControllerWithTarget:(id)target
                                    Title:(NSString *)title
                                  Message:(NSString *)message
                           preferredStyle:(UIAlertControllerStyle)preferredStyle
                              ActionTitle:(NSString *)actiontitle
                              Actionstyle:(UIAlertActionStyle)actionstyle
                        cancleActionTitle:(NSString *)cancletitle
                                   handle:(void (^)(NSInteger))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (actiontitle != nil) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actiontitle style:actionstyle handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(1);
            }
        }];
        [alert addAction:action];
    }
    if (cancletitle != nil) {
        UIAlertAction *cancleaction = [UIAlertAction actionWithTitle:cancletitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(0);
            }
        }];
        [alert addAction:cancleaction];
    }
    [target presentViewController:alert animated:YES completion:nil];
}
// 没有回调的alertview
+ (void)showAlertViewControllerWithTarget:(id)target
                                    Title:(NSString *)title
                                  Message:(NSString *)message
                              ActionTitle:(NSString *)actiontitle
                              ActionStyle:(UIAlertActionStyle)actionstyle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (actiontitle != nil) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actiontitle style:actionstyle handler:nil];
        [alert addAction:action];
    }
    [target presentViewController:alert animated:YES completion:nil];
}

// 用于多个alert按钮，默认包含取消
+ (void)showAlertViewControllerWithTarget:(id)target
                                    Title:(NSString *)title
                                  Message:(NSString *)message
                           preferredStyle:(UIAlertControllerStyle)preferredStyle
                        ActionTitlesArray:(NSArray *)actiontitlesArray
                                   handle:(void (^)(NSInteger))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(0);
        }
    }];
    [alert addAction:cancle];

    for(int i = 1; i <= actiontitlesArray.count; i++)
    {
        NSString *actiontitle = actiontitlesArray[i - 1];

        UIAlertAction *actions = [UIAlertAction actionWithTitle:actiontitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(i);
            }
        }];
        [alert addAction:actions];
    }
    [target presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertLabelWithTarget:(UIView*)superview Message:(NSString *)message removeDelay:(NSInteger)second
{
    UIFont *fnt = [UIFont systemFontOfSize:14];

    CGRect tmpRect = [message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat width = tmpRect.size.width+10;

    UILabel *alertlabel = [[UILabel alloc]init];
    [superview addSubview:alertlabel];
    [alertlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superview).offset(-60);
        make.centerX.equalTo(superview);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(30);
    }];
    alertlabel.text = message;
    alertlabel.layer.masksToBounds = YES;
    alertlabel.layer.cornerRadius = 5;
    alertlabel.textColor = [UIColor whiteColor];
    alertlabel.font = [UIFont systemFontOfSize:14];
    alertlabel.textAlignment = NSTextAlignmentCenter;
    alertlabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.6];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertlabel removeFromSuperview];
    });
}

@end
