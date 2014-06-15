//
//  SocketTaskOperate.h
//  Socket
//
//  Created by liangpengshuai on 14-5-9.
//  Copyright (c) 2014年 liangpengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperateWithJson.h"
#import "SocketServer.h"
#import "OperateDatabase.h"
#import "PlayRadio.h"

@protocol SocketTaskOperateDelegate



@end

@interface SocketTaskOperate : NSObject <UIAlertViewDelegate>
+ (void)DistributeMsg:(NSData *)MsgFromServer;



@end
