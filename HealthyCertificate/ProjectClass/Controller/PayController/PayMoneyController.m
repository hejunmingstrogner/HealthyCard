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

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)
@interface PayMoneyController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation PayMoneyController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    [self.navigationController popViewControllerAnimated:YES];
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
        return PXFIT_HEIGHT(322);
    }
    else if (((BaseTBCellItem *)_dataArray[indexPath.section]).cellStyle == STYLE_HEATHYCINFO){
        //return PXFIT_HEIGHT(178);
        return 105;
    }
//    return PXFIT_HEIGHT(152);
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
        return cell;
    }
    else if (((BaseTBCellItem *)_dataArray[indexPath.section]).cellStyle == STYLE_HEATHYCINFO){
        PayInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
        if (!cell) {
            cell = [[PayInfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"info"];
        }
        cell.titleName = ((BaseTBCellItem *)_dataArray[indexPath.section]).titleText;
        cell.payManName = ((BaseTBCellItem *)_dataArray[indexPath.section]).detialText;
        cell.getManName = ((BaseTBCellItem *)_dataArray[indexPath.section]).detialText_2;
        cell.money = @"90";
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

- (CGFloat)cellheight:(NSString *)text
{
    UIFont *fnt = [UIFont systemFontOfSize:17];

    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil] context:nil];
    CGFloat he = tmpRect.size.height+10;
    return he;
}

- (void)orderBtnClicked:(UIButton *)sender
{
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
            param.amount = 1235;
            param.channel = channel;
            param.subject = @"健康证在线";
            param.body = @"知康科技健康证在线";
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
        message = @"网络连接失败，请重试";
    }
    [RzAlertView showAlertViewControllerWithViewController:self title:@"提示" Message:message ActionTitle:@"确认" ActionStyle:UIAlertActionStyleDefault handle:^(NSInteger flag) {
        if ([_delegate respondsToSelector:@selector(payMoneyFail)] && _delegate != nil) {
            [_delegate payMoneyFail];
        }
    }];
}
- (void)payCancel
{
    [RzAlertView showAlertViewControllerWithViewController:self title:@"提示" Message:@"您取消了支付" ActionTitle:@"确认" ActionStyle:UIAlertActionStyleDefault handle:^(NSInteger flag) {
        if ([_delegate respondsToSelector:@selector(payMoneyCencel)] && _delegate != nil) {
            [_delegate payMoneyCencel];
        }
    }];
}

@end
