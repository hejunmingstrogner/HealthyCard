//
//  HMSocket.m
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import "HMSocket.h"
#import "Constants.h"

#import <GCDAsyncSocket.h>

#include <arpa/inet.h>

@implementation HMSocket
{
    // use AsyncSocket Library
    GCDAsyncSocket         *_asyncSocket;
    
    //用于断线重连的定时器
    NSTimer                *_connectTimer;
}

#pragma mark - Public Methods
-(void)connectToHost:(NSString*)remoteHost Port:(NSInteger)remotePort
{
    if (!_asyncSocket){
        dispatch_queue_t queue = dispatch_queue_create("com.healthyFriends.queue", DISPATCH_QUEUE_SERIAL);
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    }
    
    NSError* error = nil;
    [_asyncSocket connectToHost:[self getIpAddressByHostName:remoteHost] onPort:remotePort error:&error];
    if (error) {
        // need fix : to deal with the situation of connect failed
        NSLog(@"HMSocket connectToHost failed : %@", error.description);
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDisconnectWithError:)]){
            [self.delegate didDisconnectWithError:error];
        }
    }
}

//send data to server
-(void)sendData:(NSData*)data
{
    [_asyncSocket writeData:data withTimeout:-1 tag:1];
}

-(void)sendData:(NSData*)data TimeOut:(NSTimeInterval)timeout
{}


#pragma mark - Singleton & Initialization
+(instancetype)getInstance{
    static HMSocket* socketInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        socketInstance = [[HMSocket alloc] init];
    });
    return socketInstance;
}

-(instancetype)init{
    if (self = [super init]){
        // need fix - if use dispatch_get_main_queue, it may be freeze the ui
        // so i choose to pass nil - (if it's not work, choose to pass own queue)
        dispatch_queue_t queue = dispatch_queue_create("com.healthyFriends.queue", DISPATCH_QUEUE_SERIAL);
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    }
    return self;
}



#pragma mark - Private Methods
//根据域名获取ip地址
-(NSString*)getIpAddressByHostName:(NSString*)strHostName
{
    NSMutableArray *tempDNS = [[NSMutableArray alloc] init];
    
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)strHostName);
    if (hostRef)
    {
        Boolean result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result == TRUE)
        {
            NSArray *addresses = (__bridge NSArray*)CFHostGetAddressing(hostRef, &result);
            
            for(int i = 0; i < addresses.count; i++)
            {
                struct sockaddr_in* remoteAddr;
                CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex((__bridge CFArrayRef)addresses, i);
                remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
                
                if(remoteAddr != NULL)
                {
                    const char *strIP41 = inet_ntoa(remoteAddr->sin_addr);
                    
                    NSString *strDNS =[NSString stringWithCString:strIP41 encoding:NSASCIIStringEncoding];
                    NSLog(@"RESOLVED %d:<%@>", i, strDNS);
                    [tempDNS addObject:strDNS];
                }
            }
        }
    }
    if (tempDNS.count != 0){
        return (NSString*)tempDNS[0];
        
    }else{
        return @"";
    }
}

#pragma mark - GCDAsyncSocketDelegate Method
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"HMSocket didConnectToHost, host: %@, port: %d", host, port);
    
    //如果是重连成功，则需要将重连服务器设置为失效状态
    if ([_connectTimer isValid]){
        [_connectTimer invalidate];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectToHost:port:)]) {
        [self.delegate didConnectToHost:host port:port];
    }
    
    //这里设置的tag会在didReadData中被优先读取
    [_asyncSocket readDataToLength:PACKAGE_LENGTH withTimeout:-1 tag:PACKAGE_HEADER];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    // need fix : 这里可以考虑用tag标签来处理粘包的问题 也可以直接先读取data数据来获得包长度(?)
    //最先开始接收到的一定是长度
    switch (tag) {
        case PACKAGE_HEADER:  //get the package header, count the length and continue to read the package body
        {
            int intSmall;
            [data getBytes:&intSmall range:NSMakeRange(0, INT_TYPE_BYTE)];
            // do not forget subtract the header length!!!
            [_asyncSocket readDataToLength:NSSwapHostIntToBig(intSmall)-PACKAGE_LENGTH withTimeout:-1 tag:PACKAGE_BODY];
        }
            break;
        case PACKAGE_BODY:     //get the package body, after that continue to read the next package header
        {
            //to do
            if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveData:)]){
                [self.delegate didReceiveData:data];
            }
            //执行到这里代表该条报文已经读取完毕，重新开始读取报文头
            [_asyncSocket readDataToLength:PACKAGE_LENGTH withTimeout:-1 tag:PACKAGE_HEADER];
        }
            break;
        default:
            NSLog(@"something unexpected happpen......need to check the whole tag system");
            break;
    }
    
    //按照现在的机制，接收数据是异步的，所以需要在处理完数据逻辑部分后，切换到主线程来更新ui
    //dispatch_async(dispatch_get_main_queue()
}

-(void) socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"HMSocket socketDidDisconnect : %@", err.description);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDisconnectWithError:)]){
        [self.delegate didDisconnectWithError:err];
    }
    
    //断线后，开启重连服务器的定时器
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reconnectToServer) userInfo:nil repeats:YES];
    [_connectTimer fire];
}

//断线重连定时器
-(void)reconnectToServer{
    [self connectToHost:SOCKET_HOST Port:SOCKET_PORT];
}

@end
