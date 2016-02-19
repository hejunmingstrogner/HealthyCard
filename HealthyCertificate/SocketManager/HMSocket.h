//
//  HMSocket.h
//  HealthyCertificate
//
//  Created by JIANGXU on 16/2/14.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HMSocketDelegate <NSObject>

- (void)didDisconnectWithError:(NSError *)error;
- (void)didConnectToHost:(NSString *)host port:(UInt16)port;
- (void)didReceiveData:(NSData *)data;

@end

@interface HMSocket : NSObject

+(instancetype)getInstance;

@property (nonatomic, weak) id<HMSocketDelegate> delegate;

//base socket operation
-(void)connectToHost:(NSString*)remoteHost Port:(NSInteger)remotePort;

-(void)sendData:(NSData*)data;

-(void)sendData:(NSData *)data Tag:(int)tag;

-(void)sendData:(NSData*)data TimeOut:(NSTimeInterval)timeout;

@end
