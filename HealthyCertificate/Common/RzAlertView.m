//
//  RzAlertView.m
//  RzAlertViewController
//
//  Created by 乄若醉灬 on 16/1/29.
//  Copyright © 2016年 乄若醉灬. All rights reserved.
//

#import "RzAlertView.h"
#import "NSDate+Custom.h"
#import "UILabel+FontColor.h"

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
//  显示一个提示label,并且在设定时间后移除
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

    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, superView.frame.size.width * 0.8, 100)];
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
    [alertView addSubview:cbutton1];
    [cbutton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(110);
        make.left.equalTo(alertView).offset(10);
    }];
    [cbutton1 setImage:[UIImage imageNamed:btn_1_imagaName] forState:UIControlStateNormal];
    [cbutton1 setTitle:btn_1_title forState:UIControlStateNormal];
    [cbutton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cbutton1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cbutton1 addClickedBlock:^(UIButton * _Nonnull sender) {
        [bgview removeFromSuperview];
        if (block) {
            block(1);
        }
    }];

    CustomButton *cbutton2 = [[CustomButton alloc]init];
    [cbutton2 setBackgroundColor:[UIColor greenColor]];
    [alertView addSubview:cbutton2];
    [cbutton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(110);
        make.right.equalTo(alertView).offset(-10);
    }];
    [cbutton2 setImage:[UIImage imageNamed:btn_2_imageName] forState:UIControlStateNormal];
    [cbutton2 setTitle:btn_2_title forState:UIControlStateNormal];
    [cbutton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cbutton2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
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

        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [actionSheetView removeFromSuperview];
        });
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
        NSLog(@"详情");
        [zhezhao removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            actionSheetView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, 150);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [actionSheetView removeFromSuperview];
        });
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
    addressLabel.font = [UIFont systemFontOfSize:14];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(actionSheetView);
        make.left.equalTo(green.mas_right).offset(5);
        make.right.equalTo(xiangqing.mas_left).offset(-5);
        make.bottom.equalTo(bohao).offset(10);
    }];

    addressLabel.numberOfLines = 0;
    if (servicePositionItem.type == 1) {
        [addressLabel setText:servicePositionItem.address textFont:[UIFont systemFontOfSize:14] WithEndText:@"临" endTextColor:[UIColor redColor]];
    }
    else {
        addressLabel.text = servicePositionItem.address;
    }

    //服务时间
    UILabel *servicetimelabel = [[UILabel alloc]init];
    [actionSheetView addSubview:servicetimelabel];
    servicetimelabel.font = [UIFont systemFontOfSize:14];
    [servicetimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom);
        make.left.equalTo(addressLabel);
        make.right.equalTo(bohao);
        make.height.mas_equalTo(40);
    }];
    NSString *sdate = [NSString stringWithFormat:@"%@(%@-%@)", [NSDate getYear_Month_DayByDate:servicePositionItem.startTime], [NSDate getHour_MinuteByDate:servicePositionItem.startTime], [NSDate getHour_MinuteByDate:servicePositionItem.endTime]];
    servicetimelabel.text = sdate;

    UIImageView *blue = [[UIImageView alloc]init];
    [actionSheetView addSubview:blue];
    blue.image = [UIImage imageNamed:@"bluetip"];
    [blue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(servicetimelabel);
        make.left.right.height.width.equalTo(green);
    }];

    CustomButton *orderBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [actionSheetView addSubview:orderBtn];
    [orderBtn setTitle:@"预约" forState:UIControlStateNormal];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(green);
        make.right.equalTo(bohao);
        make.bottom.equalTo(actionSheetView).offset(-5);
        make.top.equalTo(servicetimelabel.mas_bottom).offset(0);
    }];
    orderBtn.layer.masksToBounds = YES;
    orderBtn.layer.cornerRadius = 5;
    [orderBtn setBackgroundColor:[UIColor colorWithRed:50/255.0 green:240/255.0 blue:50/255.0 alpha:1]];
    [orderBtn addClickedBlock:^(UIButton * _Nonnull sender) {
        // 预约
        NSLog(@"预约");
        [zhezhao removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            actionSheetView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, 150);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [actionSheetView removeFromSuperview];
        });
        if (block) {
            block(1);
        }
    }];

    [UIView animateWithDuration:1 animations:^{
        actionSheetView.frame = CGRectMake(0, superView.frame.size.height - actionSheetView.frame.size.height, actionSheetView.frame.size.width, actionSheetView.frame.size.height);
    }];

    [zhezhao addClickedBlock:^(UIButton * _Nonnull sender) {
        [sender removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            actionSheetView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, 150);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [actionSheetView removeFromSuperview];
        });
        if (block) {
            block(0);
        }
    }];

}
@end
