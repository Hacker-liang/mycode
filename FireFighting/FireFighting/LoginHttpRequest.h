//
//  LoginHttpRequest.h
//  FireFighting
//
//  Created by liang pengshuai on 14-4-19.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperateWithJson.h"
#import "SuperHttpFunc.h"

@protocol LoginHttpRequestResultDelegate

- (void)DoWithLoginHttpResulat: (NSData *)resulatData;

@optional
- (void)StopLoginActivityView: (BOOL)isSucess;

@end

@interface LoginHttpRequest : SuperHttpFunc <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSMutableData *receiveData;


@property(nonatomic, assign) id <LoginHttpRequestResultDelegate>myDelegate;

- (void)HttpLogintwithPost: (NSData *)username_password;

@end