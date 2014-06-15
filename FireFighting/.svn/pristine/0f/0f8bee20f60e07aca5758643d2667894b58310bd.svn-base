//
//  DownloadAttachFileHttpRequest.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-5.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperHttpFunc.h"


@protocol DownLoadAttachFileHttpRequestDelegate

- (void)DoWithAttachFileHttpResulat: (NSData *)resulatData;
@optional
- (void)removeAttachView: (BOOL)isSucess;
- (void)updateProgress: (double)progress;


@end

@interface DownloadAttachFileHttpRequest : SuperHttpFunc <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property(nonatomic, strong) NSString *urlStr;
@property(nonatomic, strong) NSMutableData *receiveData;


@property(nonatomic, assign) id <DownLoadAttachFileHttpRequestDelegate>myDelegate;

- (void)HttpAttachFilewithPost: (NSData *)fileContent;
- (void)cancleDownload;
@end
