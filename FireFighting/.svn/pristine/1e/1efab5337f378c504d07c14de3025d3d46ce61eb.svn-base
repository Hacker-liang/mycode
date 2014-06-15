//
//  ReceiveFileHttpRequest.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-3.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperHttpFunc.h"


@protocol ReceiveFileHttpRequestResultDelegate

- (void)DoWithFileReceiveHttpResulat: (NSData *)resulatData;
@optional
- (void)StopActivityView: (BOOL)isSucess;


@end

@interface ReceiveFileHttpRequest : SuperHttpFunc <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSString *urlStr;
@property(nonatomic, strong) NSMutableData *receiveData;


@property(nonatomic, assign) id <ReceiveFileHttpRequestResultDelegate>myDelegate;

- (void)HttpFileReveivewithPost: (NSData *)fileContent;
@end
