//
//  HMNetworkEngine.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HMNetworkEngine.h"

#import "Constants.h"

#import "NSString+Count.h"

#import "HMDataOperate.h"
#import "PackageOperation.h"
#import "HMSocket.h"

#import "StringPacket.h"
#import "ProxyHeartBeatPacket.h"
#import "QueueServerHeartBeatPacket.h"
#import "ProxyPDAVertificationPacket.h"

#import "PersonInfoOfPhonePacket.h"
#import "CompanyInfoOfPhonePacket.h"

PersonInfoOfPhonePacket* gPersonInfo;
CompanyInfoOfPhonePacket* gCompanyInfo;



@interface HMNetworkEngine()<HMSocketDelegate>
{
    //用于定时向代理服务器发送心跳包的定时器
    NSTimer                         *_heartBeatToProxyServerTimer;
    
    //用于定时向排队服务器发送心跳包的定时器
    NSTimer                         *_heartBeatToQueueServerTimer;
    
    //心跳包
    QueueServerHeartBeatPacket      *_queueServerHeartBeatPacket;
    ProxyHeartBeatPacket            *_proxyHeartBeatPacket;
}
@end


@implementation HMNetworkEngine

#pragma mark - Life Circle
-(instancetype)init
{
    if (self = [super init]){
        [HMSocket getInstance].delegate = self;
    }
    return self;
}


+(instancetype)getInstance
{
    static HMNetworkEngine* sharedHMNetworkEngine = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHMNetworkEngine = [[HMNetworkEngine alloc] init];
    });
    return sharedHMNetworkEngine;
}


#pragma mark - HMSocket Delegate
- (void)didDisconnectWithError:(NSError *)error
{
    NSLog(@"didDisconnectWithError :%@", error.description);
    
    [_heartBeatToProxyServerTimer invalidate];
    if (self.delegate && [self.delegate respondsToSelector:@selector(setUpControlFailed)])
    {
        [self.delegate setUpControlFailed];
    }
}

- (void)didConnectToHost:(NSString *)host port:(UInt16)port
{
    //连接成功后，需要先向服务端发送心跳包
    [self initProxyServerPacket];
    [self initQueueServerPacket];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(setUpControlSucceed)])
    {
        [self.delegate setUpControlSucceed];
    }

    
    dispatch_async(dispatch_get_main_queue(), ^{
        _heartBeatToProxyServerTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(proxyServerTimerTriggered) userInfo:nil repeats:YES];
        [_heartBeatToProxyServerTimer fire];
    });
    
}

- (void)didReceiveData:(NSData *)data
{
    NSInteger index = 0;
    //收到的协议格式为  外层协议(1) + server + ip + 内层协议(1) + 具体内容
    short outLayerProtocol =  [[PackageOperation getInstance] outerLayerProtocol:data Index:&index];
    
    if (outLayerProtocol == SERVER_STATUS_ECHO){
        NSLog(@"来自统一认证服务器的心跳包响应");
        //[self sendPacketToQueueServer:_queueServerHeartBeatPacket];
    }else if (outLayerProtocol == SERVER_PROXY_LIST_QUERY){
        NSLog(@"查询得到排队服务器列表");
        if (self.delegate && [self.delegate respondsToSelector:@selector(queueServerListResult:Index:)]){
            [self.delegate queueServerListResult:data Index:&index];
        }
    }else if (outLayerProtocol == SERVER_PROXY_CLIENT_DATA){
        //解析内层协议相关
        [self doTask:data Index:&index];
    }else{
        NSLog(@"NetworkEngine : didReceiveData get the outLayerProtocol error");
    }
}

#pragma mark - Public Methods
-(void)startControl
{
    if ([HMSocket getInstance].isConnected == YES){
        if (self.delegate && [self.delegate respondsToSelector:@selector(setUpControlSucceed)])
        {
            [self.delegate setUpControlSucceed];
        }
        return;
    }
    [[HMSocket getInstance] connectToHost:SOCKET_HOST Port:SOCKET_PORT];
}

-(void)queryServerList
{
    StringPacket* stringPacket = [[StringPacket alloc] initWith:@"tijian" Type:SERVER_PROXY_LIST_QUERY];
    [self sendPacketToProxyServer:stringPacket];
}

-(void)askLoginInfo:(NSString*)phoneNum
{
    ProxyPDAVertificationPacket* packet = [[ProxyPDAVertificationPacket alloc] init];
    packet.phoneNum = phoneNum;
    [self sendPacketToQueueServer:packet];
}


#pragma mark - Private Methods
-(void)proxyServerTimerTriggered{
    [self sendPacketToProxyServer:_proxyHeartBeatPacket];
}

//Proxy Server Packet
-(void)initProxyServerPacket
{
    _proxyHeartBeatPacket = [[ProxyHeartBeatPacket alloc] init];
}

-(void)sendPacketToProxyServer:(BasePacket*)packet
{
    NSMutableData* resultData = [[NSMutableData alloc] init];
    [[HMDataOperate getInstance] addProxyLayerWith:packet To:resultData];
    [[HMSocket getInstance] sendData:resultData];
}

//Queue Server Packet
-(void)initQueueServerPacket
{
    _queueServerHeartBeatPacket = [[QueueServerHeartBeatPacket alloc] initWithType:0];
}

-(void)sendPacketToQueueServer:(BasePacket*)packet
{
    NSMutableData* resultData = [[NSMutableData alloc] init];
    [[PackageOperation getInstance] addQueueLayerWith:packet To:resultData];
    [[HMSocket getInstance] sendData:resultData Tag:2];
}

//解析内层数据包 外层协议 + server + ip + 长度 + 内层协议 + 具体内容
-(void)doTask:(NSData*)data Index:(NSInteger*)index{
    (*index) += [self.serverID get256StingLength];
    [[HMDataOperate getInstance] readShortString:data Index:index];
    (*index) +=  PACKAGE_LENGTH;
    short innerProtocol =  [[PackageOperation getInstance] innerLayerProtocol:data Index:index];
    switch (innerProtocol) {
            //接收到客户信息包 包括(个人信息包和单位信息包)
        case PROXY_PDA_CUSTOMER_INFO:
        {
            gPersonInfo = [[PersonInfoOfPhonePacket alloc] init];
            gCompanyInfo = [[CompanyInfoOfPhonePacket alloc] init];
            
            [[PackageOperation getInstance] getPersonInfo:gPersonInfo CompanyInfo:gCompanyInfo Index:index From:data];
            if (self.delegate && [self.delegate respondsToSelector:@selector(getLoginInfoSucceed)]){
                [self.delegate getLoginInfoSucceed];
            }
        }
            
            break;
        default:
            break;
    }
}

@end
