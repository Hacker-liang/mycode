//
//  SocketServer.h
//  Socket
//
//  Created by liangpengshuai on 14-5-7.
//  Copyright (c) 2014年 liangpengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "OperateWithJson.h"
#import "SocketTaskOperate.h"
#import "UserInfomation.h"

@interface SocketServer : NSObject <AsyncSocketDelegate>


@property (strong, nonatomic) AsyncSocket *asyncSocket;
@property (assign) BOOL isConnected;
@property (strong, nonatomic) UserInfomation *userInfo;

+ (SocketServer *)shareSocketServer;
- (void)connectToServer;
- (void)WriteDataToServer:(NSData *)MsgToServer;

@end
