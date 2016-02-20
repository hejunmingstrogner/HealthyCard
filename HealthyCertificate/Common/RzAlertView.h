//
//  RzAlertView.h
//  RzAlertViewController
//
//  Created by 乄若醉灬 on 16/1/29.
//  Copyright © 2016年 乄若醉灬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^ButtonActionBlock)(UIButton *sender);

@interface CustomButton : UIButton

@property(nonatomic,copy)ButtonActionBlock block;
- (void)addClickedBlock:(ButtonActionBlock)block;

@end

@interface RzAlertView : UIView
{
    UIView *backgroundView;                 // 背景
    UIView *alertView;                      // 提示框
    UILabel *titleLabel;                    // 标题    标题支持2排显示，尽量不要太长
    UIActivityIndicatorView *activityView;  // 旋转框

    BOOL isshowing;
}
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  初始化，在使用alertview时，不使用此方法
 *
 *  @return
 */
- (instancetype)init;

/**
 *  调用等待提示框时，使用此方法
 *
 *  @param superView 需要显示的界面
 *  @param title     显示的title
 *
 *  @return 
 */
- (instancetype)initWithSuperView:(UIView *)superView Title:(NSString *)title;

- (void)show;

- (void)close;

- (void)removeAlertView;

/**
 *  一个或两个按钮的AlertView  1 执行action，0 执行取消
 *
 *  @param target         在类对象中只需传入“self”即可
 *  @param title          提示窗口标题
 *  @param message        信息
 *  @param preferredStyle 类型：弹出框 下拉框
 *  @param actiontitle    action的标题
 *  @param actionstyle    类型
 *  @param block          回调  flag ＝ 1 执行action，flag ＝ 0 执行取消
 *  @param cancleActionTitle 取消按钮的标题
 */
+ (void)showAlertViewControllerWithTarget:(nullable id)target
                                    Title:(nullable NSString *)title
                                  Message:(nullable NSString *)message
                           preferredStyle:(UIAlertControllerStyle)preferredStyle
                              ActionTitle:(nullable NSString *)actiontitle
                              Actionstyle:(UIAlertActionStyle)actionstyle
                        cancleActionTitle:(nullable NSString *)cancletitle
                                   handle:(void(^)(NSInteger flag))block;

/**
 *  仅用于显示提示信息，没有action事件回调
 *
 *  @param target      传入使用对象的指针 “self”
 *  @param title       title
 *  @param message     message
 *  @param actiontitle actionTitle
 *  @param actionstyle style
 */
+ (void)showAlertViewControllerWithTarget:(nullable id)target
                                    Title:(nullable NSString *)title
                                  Message:(nullable NSString *)message
                              ActionTitle:(nullable NSString *)actiontitle
                              ActionStyle:(UIAlertActionStyle)actionstyle;


/**
 *  显示一个包含多个按钮的alert，按钮title在Array中设置，block回调以1开始，自动添加取消按钮
 *
 *  @param target            self
 *  @param title             title
 *  @param message           message
 *  @param preferredStyle    style
 *  @param actiontitlesArray 按钮的标题
 *  @param block             点击按钮的回调，默认包含取消，为0，其他按钮从1开始设置
 */
+ (void)showAlertViewControllerWithTarget:(nullable id)target
                                    Title:(nullable NSString *)title
                                  Message:(nullable NSString *)message
                           preferredStyle:(UIAlertControllerStyle)preferredStyle
                        ActionTitlesArray:(nullable NSArray *)actiontitlesArray
                                   handle:(void(^)(NSInteger flag))block;

/**
 *  显示一个提示label,并且在设定时间后移除
 *
 *  @param superview 当前页面的self.view
 *  @param message   显示的数据
 *  @param second    秒数
 */
+ (void)showAlertLabelWithTarget:(nullable UIView*)superview Message:(NSString *)message removeDelay:(NSInteger)second;


/**
 *
 *
 *  @param superView       当前要显示的界面的view
 *  @param title           提示框的title
 *  @param btn_1_title     第一个按钮的标题
 *  @param btn_1_imagaName 第一个按钮的图片
 *  @param btn_2_title     第二个按钮的标题
 *  @param btn_2_imageName 第二个按钮的图片
 *  @param block           点击按钮之后的回调
 */
+ (void)showAlertWithTarget:(UIView *)superView Title:(NSString *)title oneButtonTitle:(NSString *)btn_1_title oneButtonImageName:(NSString *)btn_1_imagaName twoButtonTitle:(NSString *)btn_2_title twoButtonImageName:(NSString *)btn_2_imageName handle:(void(^)(NSInteger flag))block;
@end
NS_ASSUME_NONNULL_END