//
//  RzAlertView.m
//  RzAlertViewController
//
//  Created by 乄若醉灬 on 16/1/29.
//  Copyright © 2016年 乄若醉灬. All rights reserved.
//

#import "RzAlertView.h"

#import "Constants.h"

#import "NSDate+Custom.h"
#import "UILabel+FontColor.h"
#import "UIFont+Custom.h"
#import "UIColor+Expanded.h"

#import "WZFlashButton.h"

#define ALERT_MARGIN ([UIScreen mainScreen].bounds.size.width - ALERT_WIDTH)/2
#define ALERT_WIDTH 300
#define ALERT_HEIGHT 30

#pragma mark -旋转等待框 RZAlertViewWaitAlertView
@interface RZAlertViewWaitAlertView : UIView
{
    UIView *backgroundView;                 // 背景
    UIView *alertView;                      // 提示框
}
@property (nonatomic, strong)UILabel *titleLabel;                    // 标题    标题支持2排显示，尽量不要太长
@property (nonatomic, strong) UIActivityIndicatorView *activityView;  // 旋转框
@end

@implementation RZAlertViewWaitAlertView


- (instancetype)initWithWaitAlert:(NSString *)title
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        // 黑色背景遮罩
        backgroundView = [[UIView alloc]initWithFrame:self.frame];
        backgroundView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.5];
        backgroundView.alpha = 0;
        [self addSubview:backgroundView];

        alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
        alertView.center = backgroundView.center;
        alertView.backgroundColor = [UIColor colorWithRed:40/255.0 green:44/255.0 blue:50/255.0 alpha:0.7];
        [self addSubview:alertView];

        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 10;

        // 显示的提示文字
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 200, 45)];
        [alertView addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
        _titleLabel.text = title;
        CGFloat h_y;
        if (title.length == 0) {
            h_y = alertView.bounds.size.height/2;
        }
        else {
            h_y = alertView.bounds.size.height/2 + 5;
        }
        // 旋转的菊花
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = CGPointMake(alertView.bounds.size.width/2, h_y);
        [alertView addSubview:_activityView];

        alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    }
    return self;
}

- (void)show{
    [_activityView startAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        backgroundView.alpha = 1;
    } completion:nil];
}

- (void)close{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
            backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

@end



#pragma mark - 自定义的按钮

@implementation CustomButton

- (void)addClickedBlock:(ButtonActionBlock)block
{
    _block = block;
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton *)button
{
    if (_block) {
        _block(button);
    }
}

@end

@interface RzAlertView()

@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) NSString *title;

@end

#pragma mark -RzAlertView class
@implementation RzAlertView

#pragma mark 用于显示一个label，显示提示信息
- (instancetype)initWiAlertLabel
{
    if (self = [super init]) {
        self.frame = CGRectMake(ALERT_MARGIN, 80, ALERT_WIDTH, ALERT_HEIGHT);
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.layer.masksToBounds = YES;
        _alertLabel.layer.cornerRadius = 5;
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.font = [UIFont systemFontOfSize:15];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.6];
        [self addSubview:_alertLabel];
        _alertLabel.frame = CGRectMake(0, 0, ALERT_WIDTH, ALERT_HEIGHT);
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    _alertLabel.text = title;
}
// 显示一个message到label
+ (void)showAlertLabelWithMessage:(NSString *)message removewDelay:(NSInteger)second
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (int i = 0; i < window.subviews.count; i++) {
        if ([[window.subviews objectAtIndex:i] isKindOfClass:[RzAlertView class]]) {
            RzAlertView *alertview = [window.subviews objectAtIndex:i];
            [UIView animateWithDuration:0.5 animations:^{
                alertview.frame = CGRectMake(ALERT_MARGIN, CGRectGetMaxY(alertview.frame) + 2, ALERT_WIDTH, ALERT_HEIGHT);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    alertview.alpha = 0.01;
                } completion:^(BOOL finished) {
                    [alertview removeFromSuperview];
                }];
            }];
        }
    }
    RzAlertView *alertview = [[RzAlertView alloc]initWiAlertLabel];
    alertview.title = message;
    [window addSubview:alertview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertview removeFromSuperview];
    });
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

+ (void)showAlertViewControllerWithViewController:(id)controller title:(NSString *)title Message:(NSString *)message ActionTitle:(NSString *)actiontitle ActionStyle:(UIAlertActionStyle)actionstyle handle:(void (^)(NSInteger))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (actiontitle != nil) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actiontitle style:actionstyle handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(1);
            }
        }];
        [alert addAction:action];
    }
    [controller presentViewController:alert animated:YES completion:nil];
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
//  显示一个提示label,并且在设定时间后移除
+ (void)showAlertLabelWithTarget:(UIView*)superview Message:(NSString *)message removeDelay:(NSInteger)second
{
    [RzAlertView showAlertLabelWithMessage:message removewDelay:second];
}

// 显示两个自定义按钮
+ (void)showAlertWithTarget:(UIView *)superView
                      Title:(NSString *)title
             oneButtonTitle:(NSString *)btn_1_title
         oneButtonImageName:(NSString *)btn_1_imagaName
             twoButtonTitle:(NSString *)btn_2_title
         twoButtonImageName:(NSString *)btn_2_imageName
                     handle:(void (^)(NSInteger))block
{
    UIView *bgview = [[UIView alloc]initWithFrame:superView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.7];
    [superView addSubview:bgview];

    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 126*2 + 30, 110)];
    [bgview addSubview:alertView];
    alertView.center = CGPointMake(superView.frame.size.width/2, superView.frame.size.height/2);
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 5;

    UILabel *titleLabel = [[UILabel alloc]init];
    [alertView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertView).offset(10);
        make.centerX.equalTo(alertView);
        make.height.mas_equalTo(30);
    }];
    titleLabel.text = title;
    CustomButton *cbutton1 = [[CustomButton alloc]init];
    [cbutton1 setBackgroundColor:[UIColor greenColor]];
    cbutton1.layer.masksToBounds = YES;
    cbutton1.layer.cornerRadius = 5;
    [alertView addSubview:cbutton1];
    [cbutton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(126);
        make.left.equalTo(alertView).offset(10);
    }];
    [cbutton1 setImage:[UIImage imageNamed:@"personcustom"] forState:UIControlStateNormal];
    [cbutton1 addClickedBlock:^(UIButton * _Nonnull sender) {
        [bgview removeFromSuperview];
        if (block) {
            block(1);
        }
    }];

    CustomButton *cbutton2 = [[CustomButton alloc]init];
    [cbutton2 setBackgroundColor:[UIColor greenColor]];
    [alertView addSubview:cbutton2];
    cbutton2.layer.masksToBounds = YES;
    cbutton2.layer.cornerRadius = 5;
    [cbutton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(126);
        make.right.equalTo(alertView).offset(-10);
    }];
    [cbutton2 setImage:[UIImage imageNamed:@"unitcustom"] forState:UIControlStateNormal];
    [cbutton2 addClickedBlock:^(UIButton * _Nonnull sender) {
        [bgview removeFromSuperview];
        if (block) {
            block(2);
        }
    }];
}

// @param block     回调 0 取消，1预约，2显示基本信息，3拨打电话
+ (void)showActionSheetWithTarget:(UIView *)superView
                  servicePosition:(ServersPositionAnnotionsModel *)servicePositionItem
                           handle:(void (^)(NSInteger))block
{
    CustomButton *zhezhao = [CustomButton buttonWithType:UIButtonTypeCustom];
    [superView addSubview:zhezhao];
    zhezhao.frame = superView.frame;

    UIView *actionSheetView = [[UIView alloc]init];
    actionSheetView.backgroundColor = [UIColor whiteColor];
    actionSheetView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, 150);
    [superView addSubview:actionSheetView];

    CustomButton *bohao = [CustomButton buttonWithType:UIButtonTypeCustom];
    [actionSheetView addSubview:bohao];
    [bohao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(actionSheetView).offset(10);
        make.right.equalTo(actionSheetView).offset(-10);
        make.width.height.mas_equalTo(35);
    }];
    [bohao setImage:[UIImage imageNamed:@"phonecall"] forState:UIControlStateNormal];
    [bohao addClickedBlock:^(UIButton * _Nonnull sender) {
        // 拨号
        NSLog(@"拨号");
        [zhezhao removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            actionSheetView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, 150);

        } completion:^(BOOL finished) {
            [actionSheetView removeFromSuperview];
        }];
        if (block) {
            block(3);
        }
    }];

    CustomButton *xiangqing = [CustomButton buttonWithType:UIButtonTypeCustom];
    [actionSheetView addSubview:xiangqing];
    [xiangqing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(bohao);
        make.right.equalTo(bohao.mas_left).offset(-10);
    }];
    [xiangqing setImage:[UIImage imageNamed:@"xiangqing"] forState:UIControlStateNormal];
    [xiangqing addClickedBlock:^(UIButton * _Nonnull sender) {
        // 详情
        [zhezhao removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            actionSheetView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, 150);
        } completion:^(BOOL finished) {
            [actionSheetView removeFromSuperview];
        }];

        if (block) {
            block(2);
        }
    }];

    UIImageView *green = [[UIImageView alloc]init];
    [actionSheetView addSubview:green];
    green.image = [UIImage imageNamed:@"greentip"];
    [green mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bohao);
        make.left.equalTo(actionSheetView).offset(10);
        make.width.height.mas_equalTo(10);
    }];

    // 地址
    UILabel *addressLabel = [[UILabel alloc]init];
    [actionSheetView addSubview:addressLabel];
    addressLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(actionSheetView);
        make.left.equalTo(green.mas_right).offset(5);
        make.right.equalTo(xiangqing.mas_left).offset(-5);
        make.bottom.equalTo(bohao).offset(10);
    }];

    addressLabel.numberOfLines = 0;
//    if (servicePositionItem.type == 1) {
//        [addressLabel setText:servicePositionItem.address textFont:[UIFont systemFontOfSize:14] WithEndText:@"临" endTextColor:[UIColor redColor]];
//    }
//    else {
//        addressLabel.text = servicePositionItem.address;
//    }
    addressLabel.text = servicePositionItem.address;
    //服务时间
    UILabel *servicetimelabel = [[UILabel alloc]init];
    [actionSheetView addSubview:servicetimelabel];
    servicetimelabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
    [servicetimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom);
        make.left.equalTo(addressLabel);
        make.right.equalTo(bohao);
        make.height.mas_equalTo(40);
    }];
    if(servicePositionItem.type == 1){ //移动服务点
        NSString *sdate = [NSString stringWithFormat:@"%@(%@-%@)", [NSDate getYear_Month_DayByDate:servicePositionItem.startTime/1000], [NSDate getHour_MinuteByDate:servicePositionItem.startTime/1000], [NSDate getHour_MinuteByDate:servicePositionItem.endTime/1000]];
        servicetimelabel.text = sdate;
    }
    else{
        NSString *sdate = [NSString stringWithFormat:@"工作日(%@-%@)", [NSDate getHour_MinuteByDate:servicePositionItem.startTime/1000], [NSDate getHour_MinuteByDate:servicePositionItem.endTime/1000]];
        servicetimelabel.text = sdate;
    }


    UIImageView *blue = [[UIImageView alloc]init];
    [actionSheetView addSubview:blue];
    blue.image = [UIImage imageNamed:@"bluetip"];
    [blue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(servicetimelabel);
        make.left.right.height.width.equalTo(green);
    }];

    if (servicePositionItem.type == 0 && (servicePositionItem.checkMode & 4) == 0){

    }

    CustomButton *orderBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [actionSheetView addSubview:orderBtn];
    [orderBtn setBackgroundColor:[UIColor colorWithRGBHex:HC_Base_Green]];
    [orderBtn setTitle:@"预    约" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(green);
        make.right.equalTo(bohao);
        make.bottom.equalTo(actionSheetView).offset(-10);
        make.top.equalTo(servicetimelabel.mas_bottom).offset(0);
    }];
    orderBtn.layer.masksToBounds = YES;
    orderBtn.layer.cornerRadius = 5;
    [orderBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        [zhezhao removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            actionSheetView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, 150);
        } completion:^(BOOL finished) {
            [actionSheetView removeFromSuperview];
        }];
        if (block) {
            block(1);
        }
    }];
    if (servicePositionItem.type == 0 && (servicePositionItem.checkMode & 4) == 0){
        orderBtn.enabled = NO;
        [orderBtn setBackgroundColor:[UIColor lightGrayColor]];
    }


    [UIView animateWithDuration:1 animations:^{
        actionSheetView.frame = CGRectMake(0, superView.frame.size.height - actionSheetView.frame.size.height, actionSheetView.frame.size.width, actionSheetView.frame.size.height);
    }];

    [zhezhao addClickedBlock:^(UIButton * _Nonnull sender) {
        [sender removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            actionSheetView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, 150);
        } completion:^(BOOL finished) {
            [actionSheetView removeFromSuperview];
        }];
        if (block) {
            block(0);
        }
    }];
}

// 显示两个按钮，取消按钮默认为 “提示”状态
+ (void)showAlertViewControllerWithController:(UIViewController *)target title:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancleTitle:(NSString *)cancleTitle handle:(void (^)(NSInteger))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(1);
        }
    }];
    [alert addAction:confirm];
    UIAlertAction *cancleaction = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(0);
        }
    }];
    [alert addAction:cancleaction];
    [target presentViewController:alert animated:YES completion:nil];
}

// 显示旋转等待框
+ (void)ShowWaitAlertWithTitle:(NSString *)title
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (int i = 0; i < window.subviews.count; i++) {
        if ([[window.subviews objectAtIndex:i] isKindOfClass:[RZAlertViewWaitAlertView class]]) {
            RZAlertViewWaitAlertView *alert = [window.subviews objectAtIndex:i];
            if(title != nil){
                alert.titleLabel.text = title;
            }
            return ;
        }
    }
    RZAlertViewWaitAlertView *alertView = [[RZAlertViewWaitAlertView alloc]initWithWaitAlert:title];
    [window addSubview:alertView];
    [alertView show];
}

// 关闭旋转等待框
+ (void)CloseWaitAlert
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (int i = 0; i < window.subviews.count; i++) {
        if ([[window.subviews objectAtIndex:i] isKindOfClass:[RZAlertViewWaitAlertView class]]) {
            RZAlertViewWaitAlertView *alertView = [window.subviews objectAtIndex:i];
            [alertView close];
        }
    }
}


@end
