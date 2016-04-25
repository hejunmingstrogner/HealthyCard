//
//  PayMoneyController.m
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/3/8.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "PayMoneyController.h"

#import "Constants.h"
#import <Masonry.h>

#import "UIColor+Expanded.h"
#import "UIFont+Custom.h"
#import "UIButton+Easy.h"
#import "UILabel+FontColor.h"
#import "UIButton+HitTest.h"

#import "HttpNetworkManager.h"
#import "RzAlertView.h"

#import "BaseTBCellItem.h"
#import "PayInfoViewCell.h"
#import "PayTypeViewCell.h"
#import "QRController.h"
#import "CustomerTest.h"
#import "ChargeParameter.h"
#import "ETDetail.h"
#import "SDCycleScrollView.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)
@interface PayMoneyController ()<UITableViewDataSource, UITableViewDelegate>
{

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
    self.money = @"";
    [self initNavgation];

    [self initData];

    [self initSubView];
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
    [self.navigationController popViewControllerAnimated:NO];
    if([_delegate respondsToSelector:(@selector(payMoneyCencel))] && _delegate)
    {
        [_delegate payMoneyCencel];
    }
}

- (void)initSubView
{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate= self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)initData
{

    BaseTBCellItem *item0 = [[BaseTBCellItem alloc]initWithImage:[UIImage imageNamed:@"payhead"] title:nil detial:nil cellStyle:STYLE_HEADERIMAGE];
    BaseTBCellItem *item1 = [[BaseTBCellItem alloc]initWithImage:nil title:@"" detial:@"" detial2:@"" cellStyle:STYLE_HEATHYCINFO];
    BaseTBCellItem *item2 = [[BaseTBCellItem alloc]initWithImage:[UIImage imageNamed:@"wx"] title:@"微信支付" detial:@"推荐安装微信5.0及以上版本" cellStyle:STYLE_WXPAY flag:0];
    BaseTBCellItem *item3 = [[BaseTBCellItem alloc]initWithImage:[UIImage imageNamed:@"alipay"] title:@"支付宝支付" detial:@"推荐有支付宝账号的使用" cellStyle:STYLE_ALIPAY flag:0];
    BaseTBCellItem *item4 = [[BaseTBCellItem alloc]initWithImage:[UIImage imageNamed:@"daifukuan"] title:@"找人代付" detial:@"让他人扫描二维码替您支付" cellStyle:STYLE_DAIFUKUAN flag:0];
    _dataArray = [[NSMutableArray alloc]initWithObjects:item0, item1, item2, item3, item4, nil];

    if(self.chargetype == BatchCharge){
        [_dataArray removeObject:item4];    // 单位批量支付 不使用 找人代付
        float amountMoney = 0;
        for (CustomerTest *customertest in _CustomerTestArray) {
            amountMoney += customertest.needMoney;
        }
        self.money = [NSString stringWithFormat:@"%f", amountMoney];
    }
    else {
        [self getCityPrice];
    }
}

- (void)getCityPrice
{
    [RzAlertView ShowWaitAlertWithTitle:[NSString stringWithFormat:@"获取%@预约价格...",_cityName]];
    __weak typeof(self) weakself = self;
    [[HttpNetworkManager getInstance]getCustomerTestChargePriceWithCityName:_cityName checkType:nil resultBlcok:^(NSString *result, NSError *error) {
        [RzAlertView CloseWaitAlert];
        if (!error) {
            weakself.money = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }
        else {
            [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"获取支付金额失败，请重试" preferredStyle:UIAlertControllerStyleAlert ActionTitle:@"重试" Actionstyle:UIAlertActionStyleDestructive cancleActionTitle:@"取消" handle:^(NSInteger flag) {
                if (flag != 0) {
                    [weakself getCityPrice];
                }
                else {
                    [weakself backToPre:nil];
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
        return self.view.frame.size.width * 161 /360;
    }
    else if (((BaseTBCellItem *)_dataArray[indexPath.section]).cellStyle == STYLE_HEATHYCINFO){
        return 75;
    }
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (((BaseTBCellItem *)_dataArray[indexPath.section]).cellStyle == STYLE_HEADERIMAGE) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cycleImage"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cycleImage"];
            NSArray *images = @[@"banner1", @"banner2", @"banner3"];
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            // 图片轮播view
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height) shouldInfiniteLoop:YES imageNamesGroup:images];
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            [cell.contentView addSubview:cycleScrollView];
            cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cycleScrollView.autoScrollTimeInterval = 4;
        }
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
        [self orderBtnClicked:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
                case STYLE_DAIFUKUAN:{
                    if (self.chargetype == BatchCharge) {
                        [RzAlertView showAlertViewControllerWithTarget:self Title:@"提示" Message:@"批量支付中暂不支持他人代付" ActionTitle:@"明白了" ActionStyle:UIAlertActionStyleDefault];
                        return;
                    }
                    // 他人代付
                    [self letOthersPay];
                    return;
                }
                default:
                    channel = nil;
                    break;
            }
            if (channel == nil) {
                return;
            }
            // 批量支付
            if (self.chargetype == BatchCharge) {
                [self payMoneyByBatchCharge:channel];
            }
            else {  // 个人支付
                [self payMoneyByOneSelf:channel];
            }

            return;
        }
    }
}
// 个人支付
- (void)payMoneyByOneSelf:(NSString *)channel{
    ChargeBusinessForCustomerTest *businessobj = [[ChargeBusinessForCustomerTest alloc]init];
    businessobj.enumType = _chargetype;
    businessobj.checkCode = _checkCode;

    ChargeParameter *param = [[ChargeParameter alloc]init];
    param.amount = [_money floatValue] *100;
    param.channel = channel;
    param.subject = @"健康证在线";
    param.body = @"健康证在线是专注于为从业人员提供在线一键办证服务的平台，实现医疗机构和从业人员的无缝对接";
    param.businessObj = businessobj;
    __weak typeof (self) weakself = self;
    [[HttpNetworkManager getInstance]payMoneyWithChargeParameter:param viewController:self resultBlock:^(NSString *result, NSError *error) {
        if (!error) {
            if ([result isEqualToString:@"success"]) {
                [weakself paySuccessed];
            }
        }
        else{
            if([result isEqualToString:@"cancel"]){
                [weakself payCancel];
            }
            else{
                [weakself payFail:error result:result];
            }
        }
    }];
}
// 批量支付
- (void)payMoneyByBatchCharge:(NSString *)channel
{
    ChargeBusinessObjForBatch *business = [[ChargeBusinessObjForBatch alloc]init];
    business.details = [[NSMutableArray alloc]init];
    for (CustomerTest *test in _CustomerTestArray) {
        ETDetail *detail = [[ETDetail alloc]init];
        detail.hostType = 2;
        detail.hostCode = test.checkCode;
        detail.payMoney = test.needMoney;
        [business.details addObject:detail];
    }
    ChargeParameter *param = [[ChargeParameter alloc]init];
    param.amount = [_money floatValue] *100;
    param.channel = channel;
    param.subject = @"健康证在线";
    param.body = @"健康证在线是专注于为从业人员提供在线一键办证服务的平台，实现医疗机构和从业人员的无缝对接";
    param.businessObj = business;
    __weak typeof (self) weakself = self;
    [[HttpNetworkManager getInstance]payMoneyWithChargeParameter:param viewController:self resultBlock:^(NSString *result, NSError *error) {
        if (!error) {
            if ([result isEqualToString:@"success"]) {
                [weakself paySuccessed];
            }
        }
        else{
            if([result isEqualToString:@"cancel"]){
                [weakself payCancel];
            }
            else{
                [weakself payFail:error result:result];
            }
        }
    }];

}

#pragma mark - 找他人代付
// 他人支付
- (void)letOthersPay
{
    // 他人代付
    QRController* qrController = [[QRController alloc] init];
    qrController.qrControllerType = QRController_Pay;
    qrController.qrContent = [NSString stringWithFormat:@"%@reservation_person/charge.jsp?checkCode=%@",WeixinBaseUrl,_checkCode];
    qrController.shareText = @"";
    [self.navigationController pushViewController:qrController animated:YES];

    // 去掉勾选
    [self deselectChannelPay];
}

#pragma mark - 支付之后的回调，
// 支付成功
- (void)paySuccessed
{
    [RzAlertView showAlertViewControllerWithViewController:self title:@"提示" Message:@"支付成功" ActionTitle:@"确认" ActionStyle:UIAlertActionStyleDefault handle:^(NSInteger flag) {
        if ([_delegate respondsToSelector:@selector(payMoneySuccessed)] && _delegate != nil) {
            [self.navigationController popViewControllerAnimated:YES];
            [_delegate payMoneySuccessed];
        }
    }];
}
// 支付失败
- (void)payFail:(NSError *)error result:(NSString *)result
{
    [RzAlertView showAlertViewControllerWithViewController:self title:@"提示" Message:result ActionTitle:@"确认" ActionStyle:UIAlertActionStyleDefault handle:^(NSInteger flag) {
        [self deselectChannelPay];
    }];
}
// 支付取消
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
