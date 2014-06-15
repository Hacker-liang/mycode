//
//  DownloadAttachFileHttpRequest.m
//  FireFighting
//
//  Created by liang pengshuai on 14-5-5.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "DownloadAttachFileHttpRequest.h"

@implementation DownloadAttachFileHttpRequest
{
    NSMutableURLRequest *AttachFileReques;
    NSURLConnection *connect;
}

long long mFileSize;
double currentFileSize;

- (void)HttpAttachFilewithPost: (NSData *)fileContent

{
    NSString* urlStr = [NSString stringWithFormat:@"%@AttachFileServlet", commonUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    AttachFileReques = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [AttachFileReques addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [AttachFileReques setHTTPMethod:@"POST"];
    [AttachFileReques setHTTPBody:fileContent];
    connect = [[NSURLConnection alloc] initWithRequest:AttachFileReques delegate:self startImmediately:YES];
    if (connect) {
        _receiveData = [[NSMutableData alloc] init];
    }
    [connect start];
}

- (void)cancleDownload
{
    [connect cancel];
}

#pragma mark - NSURLConnectDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_myDelegate removeAttachView:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"下载附件收到回应");
    mFileSize = [response expectedContentLength];
    currentFileSize = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
    currentFileSize += (double)[data length]/1024;
    [_myDelegate updateProgress:(double)(currentFileSize/(mFileSize/1024))];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_myDelegate DoWithAttachFileHttpResulat:_receiveData];
    
}

@end
