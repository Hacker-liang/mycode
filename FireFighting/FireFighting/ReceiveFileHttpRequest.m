//
//  ReceiveFileHttpRequest.m
//  FireFighting
//
//  Created by liang pengshuai on 14-5-3.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "ReceiveFileHttpRequest.h"

@implementation ReceiveFileHttpRequest

- (void)HttpFileReveivewithPost: (NSData *)fileContent

{
    NSString* urlStr = [NSString stringWithFormat:@"%@FileReceiveServlet", commonUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *receiveFileReques = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [receiveFileReques addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [receiveFileReques setHTTPMethod:@"POST"];
    [receiveFileReques setHTTPBody:fileContent];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:receiveFileReques delegate:self startImmediately:YES];
    if (connect) {
        _receiveData = [[NSMutableData alloc] init];
    }
    [connect start];
}

#pragma mark - NSURLConnectDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_myDelegate StopActivityView:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"更新接收文章收到回应");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_myDelegate DoWithFileReceiveHttpResulat:_receiveData];
    
}

@end
