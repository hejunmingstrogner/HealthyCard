//
//  ServicePointCell.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/23.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "ServicePointCell.h"

#import "Constants.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

#import "UIButton+Easy.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "UILabel+FontColor.h"
#import "NSDate+Custom.h"
#import "UIButton+HitTest.h"

#import "DetailImageView.h"

#import "HttpNetworkManager.h"

#define Cell_Font FIT_FONTSIZE(24)
#define Cell_Detail_Font FIT_FONTSIZE(23)

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface ServicePointCell()
{
    UIImageView             *_picImageView;
    UILabel                 *_nameLabel;
    UILabel                 *_distanceLabel;
    UILabel                 *_locationLabel;
    UILabel                 *_timeLabel;
    
    UIImage                 *_cellIamge;
}
@end


@implementation ServicePointCell

#pragma mark - Setter & Getter
-(void)setServicePoint:(ServersPositionAnnotionsModel *)servicePoint{
    _nameLabel.text = servicePoint.name;
    
    _distanceLabel.text = [NSString stringWithFormat:@"%.1lfkm", servicePoint.distance];
    _distanceLabel.textColor = MO_RGBCOLOR(0, 169, 234);
    
    if (servicePoint.type == 1){
        _locationLabel.text = servicePoint.address;
        _timeLabel.text = [NSString stringWithFormat:@"%@(%@~%@)",
                           [NSDate getYear_Month_DayByDate:servicePoint.startTime/1000],
                           [NSDate getHour_MinuteByDate:servicePoint.startTime/1000],
                           [NSDate getHour_MinuteByDate:servicePoint.endTime/1000]];
    }
    else{
        _locationLabel.text = servicePoint.address;
        _timeLabel.text = [NSString stringWithFormat:@"工作日(%@~%@)",
                           [NSDate getHour_MinuteByDate:servicePoint.startTime/1000],
                           [NSDate getHour_MinuteByDate:servicePoint.endTime/1000]];

    }
    
    //判断是固定机构还是移动服务点
    if (servicePoint.type == 0){
        //固定服务点
        //根据机构编号去获取图片
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@hosInfo/getIntroPhoto?hosCode=%@", [HttpNetworkManager baseURL], servicePoint.cHostCode]];
        __weak typeof (self) wself = self;
        [_picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"unitLog"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil)
                return;
            __strong typeof (self) sself = wself;
            (sself->_picImageView).image = [wself reSizeImage:image toSize:(sself->_picImageView).image.size];
            (sself->_cellIamge) = image;
            
        }];
        
    }else{
        //移动服务点
        //brVehicle/getPhoto
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@brVehicle/getPhoto?uid=%@", [HttpNetworkManager baseURL], servicePoint.brOutCheckArrange.vehicleID]];
        __weak typeof (self) wself = self;
        [_picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"serverPointLogo"] options:SDWebImageRefreshCached | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil)
                return;
            __strong typeof (self) sself = wself;
            (sself->_picImageView).image = [wself reSizeImage:image toSize:(sself->_picImageView).image.size];
            (sself->_cellIamge) = image;
        }];
    }
}

#pragma mark - Life Circle
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        //cell的上半部分界面
        UIView* topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(PXFIT_HEIGHT(198));
        }];
        
        UIView* imageContainerView = [[UIView alloc] init];
        [topView addSubview:imageContainerView];
        [imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(topView);
            make.width.mas_equalTo(PXFIT_WIDTH(168)); // 24 120 24
        }];
        
        UIImage* placeHolderIamge = [UIImage imageNamed:@"serverPointLogo"];
        _picImageView = [[UIImageView alloc] init];
        [imageContainerView addSubview:_picImageView];
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(imageContainerView);
            make.width.mas_equalTo(placeHolderIamge.size.width);
            make.height.mas_equalTo(placeHolderIamge.size.height);
        }];
        _picImageView.layer.masksToBounds = YES;
        _picImageView.layer.cornerRadius = placeHolderIamge.size.width/2;
//        _picImageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
//        [_picImageView addGestureRecognizer:singleTap];
        
        UIView* topRightView = [[UIView alloc] init];
        [topView addSubview:topRightView];
        [topRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageContainerView.mas_right);
            make.right.top.bottom.mas_equalTo(topView);
        }];
        
        //门诊部名字一栏
        UIView* topRightUpView = [[UIView alloc] init];
        [topRightView addSubview:topRightUpView];
        [topRightUpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(topRightView);
            make.height.mas_equalTo(PXFIT_HEIGHT(99));
        }];
        
        UIImageView* nameIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nameIcon"]];
        [topRightUpView addSubview:nameIcon];
        
        _nameLabel = [[UILabel alloc] init];
        [topRightUpView addSubview:_nameLabel];
        _distanceLabel = [[UILabel alloc] init];
        [topRightUpView addSubview:_distanceLabel];
        
        [nameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(topRightUpView);
            make.left.mas_equalTo(topRightUpView);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topRightUpView);
            make.left.mas_equalTo(nameIcon.mas_right);
        }];
        
    
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topRightUpView);
            make.right.mas_equalTo(topRightUpView).with.offset(-PXFIT_WIDTH(24));
            make.left.greaterThanOrEqualTo(_nameLabel.mas_right).with.offset(PXFIT_WIDTH(10));
        }];
        [_distanceLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        
        
        UIView* topRightDownView = [[UIView alloc] init];
        [topRightView addSubview:topRightDownView];
        [topRightDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(topRightView);
            make.top.mas_equalTo(topRightUpView.mas_bottom);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        [topRightDownView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(topRightDownView);
            make.height.mas_equalTo(PXFIT_HEIGHT(49));
        }];
        
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [topRightDownView addSubview:_locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(topRightDownView);
            make.height.mas_equalTo(PXFIT_HEIGHT(49));
            make.top.mas_equalTo(_timeLabel.mas_bottom);
        }];
        
       
        

        UIView* lineView = [[UIView alloc] init];
        lineView.backgroundColor=[UIColor colorWithRGBHex:0xe0e0e0];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(PXFIT_WIDTH(24));
            make.right.mas_equalTo(self).with.offset(-PXFIT_WIDTH(24));
            make.top.mas_equalTo(topView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        UIView* bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(lineView.mas_bottom);
        }];
        
        UIButton* appointmenBtn = [UIButton buttonWithTitle:@"预约"
                                                       font:[UIFont fontWithType:UIFontOpenSansRegular size:Cell_Font]
                                                  textColor:[UIColor whiteColor]
                                            backgroundColor:[UIColor colorWithRGBHex:HC_Base_Blue]];
        [bottomView addSubview:appointmenBtn];
        [appointmenBtn addTarget:self action:@selector(detailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        appointmenBtn.layer.cornerRadius = 5;
        [appointmenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.top.mas_equalTo(bottomView).with.offset(PXFIT_HEIGHT(15));
            make.bottom.mas_equalTo(bottomView).with.offset(-PXFIT_HEIGHT(15));
            make.right.mas_equalTo(bottomView).with.offset(-PXFIT_WIDTH(26));
            make.width.mas_equalTo(PXFIT_WIDTH(120));
        }];
        
        UIButton* phoneCallBtn = [[UIButton alloc] init];
        [phoneCallBtn setImage:[UIImage imageNamed:@"phoneIcon"] forState:UIControlStateNormal];
        phoneCallBtn.layer.cornerRadius = 5;
        phoneCallBtn.imageView.contentMode = UIViewContentModeCenter;
        phoneCallBtn.backgroundColor = [UIColor colorWithRGBHex:HC_Base_Green];
        [bottomView addSubview:phoneCallBtn];
        [phoneCallBtn addTarget:self action:@selector(phoneCallBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [phoneCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(appointmenBtn);
            make.width.mas_equalTo(appointmenBtn);
            make.height.mas_equalTo(appointmenBtn);
            make.right.mas_equalTo(appointmenBtn.mas_left).with.offset(-PXFIT_WIDTH(60));
        }];
        
        UIButton* maskBtn = [[UIButton alloc] init];
        [bottomView addSubview:maskBtn];
        [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bottomView);
            make.top.bottom.mas_equalTo(bottomView);
            make.right.mas_equalTo(phoneCallBtn.mas_left);
        }];
        
        _nameLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Font];
        _distanceLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Detail_Font];
        _distanceLabel.textColor = MO_RGBCOLOR(70, 180, 240);
        _timeLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Detail_Font];
        _timeLabel.textColor = [UIColor colorWithRGBHex:0x6e6e6e];
        _locationLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:Cell_Detail_Font];
        _locationLabel.textColor = [UIColor colorWithRGBHex:0x6e6e6e];
    }
    return self;
}

#pragma mark - Action
-(void)phoneCallBtnClicked:(id)sender
{
    (_servicePointCellPhoneNumBtnBlock)(_servicePoint.leaderPhone);
}

-(void)detailBtnClicked:(id)sender
{
    (_serviceAppointmentBtnClickedBlock)();
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    UIImage *image;
    if (_cellIamge){
        image = _cellIamge;
    }else{
        image = _picImageView.image;
    }
    // 获得根窗口
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    
    //UIView *backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    //数据为测试数据
    DetailImageView* detailImageView = [[DetailImageView alloc] initWithImage:image TotalCount:@"10" MonthCount:@"10" Frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    //oldframe =[_picImageView convertRect:_picImageView.bounds toView:window];
    //backgroundView.backgroundColor =[UIColor blackColor];
    //backgroundView.alpha =0.5;
   //backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
   // UIImageView *imageView =[[UIImageView alloc]initWithFrame:oldframe];
    //imageView.image =image;
    //imageView.tag =1;
    //[backgroundView addSubview:imageView];
    [window addSubview:detailImageView];

    //点击图片缩小的手势
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [detailImageView addGestureRecognizer:tap];
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame =CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
//        backgroundView.alpha =1;
//    }];
}

-(void)hideImage:(UITapGestureRecognizer *)tap{
    UIView *backgroundView =tap.view;
//    UIImageView *imageView =(UIImageView *)[tap.view viewWithTag:1];
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame =oldframe;
//        backgroundView.alpha =0;
//    } completion:^(BOOL finished) {
//        [backgroundView removeFromSuperview];
//    }];
    [backgroundView removeFromSuperview];
    
}

#pragma mark - Private Methods
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}


@end
