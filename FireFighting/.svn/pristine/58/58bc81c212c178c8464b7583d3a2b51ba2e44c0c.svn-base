//
//  SocketServer.m
//  Socket
//
//  Created by liangpengshuai on 14-5-7.
//  Copyright (c) 2014年 liangpengshuai. All rights reserved.
//

#import "SocketServer.h"

static SocketServer *socketClient;
@implementation SocketServer

+ (SocketServer *)shareSocketServer
{
    @synchronized (self)
    {
        if (socketClient == nil) {
            socketClient = [[self alloc] init];
        }
    }
    return socketClient;
}

- (void)connectToServer
{
    _asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *err = nil;
    if (![_asyncSocket connectToHost:@"192.168.0.105" onPort:8088 withTimeout:5 error:&err]) {
        NSLog(@"%@", err);
    }
}

- (void)WriteDataToServer:(NSData *)MsgToServer
{
    [_asyncSocket writeData:MsgToServer withTimeout:-1 tag:0];
}

#pragma mark AsyncSocketDelegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    _userInfo = [UserInfomation shareUserInfo];
    [sock readDataWithTimeout:-1 tag:0];
    _isConnected = YES;
    NSMutableDictionary *firstLoginDataDic = [[NSMutableDictionary alloc] init];
    [firstLoginDataDic setValue:@"newclient" forKey:@"cmd"];
    [firstLoginDataDic setValue:_userInfo.userNo forKey:@"userno"];
    [self WriteDataToServer:[OperateWithJson enCodeWithDictionary:firstLoginDataDic]];
    NSLog(@"已经连接上服务器");
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"消息已经发送完成");
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"收到消息");
    NSString *readStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",readStr);
    [SocketTaskOperate DistributeMsg:data];
    [sock readDataWithTimeout:-1 tag:0];

}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)10000000000);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self connectToServer];
    });
    _isConnected = NO;
    NSLog(@"socket服务器断开");
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
}



@end
