//
//  PayMoneyController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PayMoneyController.h"
#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UIButton+HitTest.h"
#import "Constants.h"
#import <Masonry.h>
#import "BaseTBCellItem.h"
#import "PayInfoViewCell.h"
#import "PayTypeViewCell.h"
#import "HttpNetworkManager.h"
#import "RzAlertView.h"
#import "ChargeType.h"
#import "UILabel+FontColor.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)
@interface PayMoneyController ()<UITableViewDataSource, UITableViewDelegate>
{
    RzAlertView *waitAlertView;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation PayMoneyController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_cityName.length == 0) {
        _cityName = gCurrentCityName;
    }
    [self initNavgation];

    [self initSubView];

    [self initData];
}

- (void)initNavgation
{
    self.title = @"支付确认";  // 车辆牌照
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:[UIImage imageNamed:@"back"]];
    backBtn.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;
    [backBtn addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backitem;
}
// 返回前一页
- (void)backToPre:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if([_delegate respondsToSelector:(@selector(payMoneyCencel))] && _delegate)
    {
        [_delegate payMoneyCencel];
    }
}

- (void)initSubView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate= self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)initData
{

    BaseTBCellItem *item0 = [[BaseTBCellItem alloc]initWithImage:[UIImage imageNamed:@"payhead"] title:nil detial:nil cellStyle:STYLE_HEADERIMAGE];
    BaseTBCellItem *item1 = [[BaseTBCellItem alloc]initWithImage:nil title:@"健康证套餐" detial:@"张三" detial2:@"知康科技健康证在线" cellStyle:STYLE_HEATHYCINFO];
    BaseTBCellItem *item2 = [[BaseTBCellItem alloc]initWithImage:[UIImage imageNamed:@"wx"] title:@"微信支付" detial:@"推荐安装微信5.0及以上版本" cellStyle:STYLE_WXPAY flag:0];
    BaseTBCellItem *item3 = [[BaseTBCellItem alloc]initWithImage:[UIImage imageNamed:@"alipay"] title:@"支付宝支付" detial:@"推荐有支付宝账号的使用" cellStyle:STYLE_ALIPAY flag:0];

    _dataArray = [[NSMutableArray alloc]initWithObjects:item0, item1, item2, item3, nil];

    [self getCityPrice];
}

- (void)getCityPrice
{
    if (waitAlertView) {
        waitAlertView = [[RzAlertView alloc]initWithSuperView:self.view Title:@""];
    }
    waitAlertView.titleLabel.text = [NSString stringWithFormat:@"获取%@预约价格...",_cityName];
    [waitAlertView show];
    [[HttpNetworkManager getInstance]getCustomerTestChargePriceWithCityName:_cityName checkType:nil resultBlcok:^(NSString *result, NSError *error) {
        [waitAlertView close];
        if (!error) {
            self.money = result;
            [_tableView reloadData];
        }
        else {
            [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"获取支付金额失败，请重试" preferredStyle:UIAlertControllerStyleAlert ActionTitle:@"重试" Actionstyle:UIAlertActionStyleDestructive cancleActionTitle:@"取消" handle:^(NSInteger flag) {
                if (flag != 0) {
                    [self getCityPrice];
                }
                else {
                    [self backToPre:nil];
                }
            }];
        }
    }];
}

- (void)setMoney:(NSString *)money
{
    money = [NSString stringWithFormat:@"%f", [money floatValue]];
    _money = [self changeFloat:money];
}
// 有小数时，去掉小数后的无效 ‘0’
-(NSString *)changeFloat:(NSString *)stringFloat
{
    NSUInteger length = [stringFloat length];
    for(int i = 1; i<=6; i++)
    {
        NSString *subString = [stringFloat substringFromIndex:length - i];
        if(![subString isEqualToString:@"0"])
        {
            return stringFloat;
        }
        else
        {
            stringFloat = [stringFloat substringToIndex:length - i];
        }
    }
    return [stringFloat substringToIndex:length - 7];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return PXFIT_HEIGHT(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (((BaseTBCellItem *)_dataArray[indexPath.section]).cellStyle == STYLE_HEADERIMAGE) {
        return PXFIT_HEIGHT(332);
    }
    else if (((BaseTBCellItem *)_dataArray[indexPath.section]).cellStyle == STYLE_HEATHYCINFO){
        return 75;
    }
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (((BaseTBCellItem *)_dataArray[indexPath.section]).cellStyle == STYLE_HEADERIMAGE) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        UIImageView *imageview = [[UIImageView alloc]init];
        [cell addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell);
        }];
        imageview.image = [UIImage imageNamed:@"payhead"];

        UIImageView *moneyView = [[UIImageView alloc]init];
        [cell addSubview:moneyView];
        moneyView.image = [UIImage imageNamed:@"moneybg"];
        [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
            make.height.width.mas_equalTo(PXFIT_HEIGHT(322)/2.5);
        }];

        UILabel *moneylabel = [[UILabel alloc]init];
        [cell addSubview:moneylabel];
        moneylabel.textAlignment = NSTextAlignmentCenter;
        [moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(moneyView);
        }];
        [moneylabel setText:@"¥" textFont:[UIFont fontWithType:UIFontOpenSansRegular size:18] WithEndText:_money endtextFont:[UIFont fontWithType:UIFontOpenSansRegular size:21] textcolor:[UIColor whiteColor]];
        return cell;
    }
    else if (((BaseTBCellItem *)_dataArray[indexPath.section]).cellStyle == STYLE_HEATHYCINFO){
        PayInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
        if (!cell) {
            cell = [[PayInfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"info"];
        }
        cell.textLabel.text = ((BaseTBCellItem *)_dataArray[indexPath.section]).titleText;
        cell.money = _money;
        return cell;
    }
    else {
        PayTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type"];
        if (!cell) {
            cell = [[PayTypeViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"type"];
            cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:HC_Gray_Text];
            cell.textLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:16];
            cell.detailTextLabel.font = [UIFont fontWithType:UIFontOpenSansRegular size:14];
        }
        cell.imageView.image = ((BaseTBCellItem *)_dataArray[indexPath.section]).image;
        cell.textLabel.text = ((BaseTBCellItem *)_dataArray[indexPath.section]).titleText;
        cell.detailTextLabel.text = ((BaseTBCellItem *)_dataArray[indexPath.section]).detialText;
        cell.flag =  ((BaseTBCellItem *)_dataArray[indexPath.section]).flag;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 1) {
        for (int i = 0; i < _dataArray.count; i++) {
            if (i == indexPath.section) {
                ((BaseTBCellItem *)_dataArray[i]).flag = ((BaseTBCellItem *)_dataArray[i]).flag == 0 ? 1 : 0;
            }
            else {
                ((BaseTBCellItem *)_dataArray[i]).flag = 0;
            }
        }
        [_tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self orderBtnClicked:nil];
}
//
//- (CGFloat)cellheight:(NSString *)text
//{
//    UIFont *fnt = [UIFont systemFontOfSize:17];
//
//    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
//    CGFloat he = tmpRect.size.height+10;
//    return he;
//}

- (void)orderBtnClicked:(UIButton *)sender
{
    if (_money <= 0) {
        [RzAlertView showAlertLabelWithTarget:self.view Message:@"交易金额不正确" removeDelay:2];
        return;
    }
    for (BaseTBCellItem *item in _dataArray) {
        if (item.flag == 1) {
            NSString *channel;
            switch (item.cellStyle) {
                case STYLE_WXPAY:
                    channel = @"wx";
                    break;
                case STYLE_ALIPAY:
                    channel = @"alipay";
                    break;
                case STYLE_UPACP:
                    channel = @"upacp";
                    break;
                default:
                    channel = nil;
                    break;
            }
            if (channel == nil) {
                return;
            }

            ChargeParameter *param = [[ChargeParameter alloc]init];
            param.amount = [_money floatValue] *100;
            param.channel = channel;
            param.subject = @"健康证在线";
            param.body = @"知康科技健康证在线";
            param.businessObj.enumType = _chargetype;
            param.businessObj.checkCode = _checkCode;
            [[HttpNetworkManager getInstance]payMoneyWithChargeParameter:param viewController:self resultBlock:^(NSString *result, NSError *error) {
                if (!error) {
                    if ([result isEqualToString:@"success"]) {
                        [self paySuccessed];
                    }
                }
                else{
                    if([result isEqualToString:@"cancel"]){
                        [self payCancel];
                    }
                    else{
                        [self payFail:error result:result];
                    }
                }
            }];
            break;
        }
    }
}

- (void)paySuccessed
{
    [RzAlertView showAlertViewControllerWithViewController:self title:@"提示" Message:@"支付成功" ActionTitle:@"确认" ActionStyle:UIAlertActionStyleDefault handle:^(NSInteger flag) {
        if ([_delegate respondsToSelector:@selector(payMoneySuccessed)] && _delegate != nil) {
            [self backToPre:nil];
            [_delegate payMoneySuccessed];
        }
    }];
}

- (void)payFail:(NSError *)error result:(NSString *)result
{
    NSString *message;
    if ([result isEqualToString:@"fail"]) {
        message = @"支付失败，请重试";
    }
    else{
        message = [error.userInfo objectForKey:@"error"];
        if (message == nil) {
            message = @"支付失败";
        }
    }
    [RzAlertView showAlertViewControllerWithViewController:self title:@"提示" Message:message ActionTitle:@"确认" ActionStyle:UIAlertActionStyleDefault handle:^(NSInteger flag) {
        [self deselectChannelPay];
    }];

}
- (void)payCancel
{
    [RzAlertView showAlertViewControllerWithViewController:self title:@"提示" Message:@"您取消了支付" ActionTitle:@"确认" ActionStyle:UIAlertActionStyleDefault handle:^(NSInteger flag) {
        [self deselectChannelPay];
    }];

}

// 去掉选择的付款渠道
- (void)deselectChannelPay
{
    for (int i = 0; i < _dataArray.count; i++) {
        ((BaseTBCellItem *)_dataArray[i]).flag = 0;
    }
    [_tableView reloadData];
}
@end
