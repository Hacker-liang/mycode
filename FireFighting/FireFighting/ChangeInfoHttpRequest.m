//
//  ChangeInfoHttpRequest.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "ChangeInfoHttpRequest.h"

@implementation ChangeInfoHttpRequest

- (void)ChangeInfoHttpRequestWithPost:(NSData *)postData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@UpdateUserInfoServlet", commonUrl];
    NSURL *changeURL = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest *changeRequest = [[NSMutableURLRequest alloc] initWithURL:changeURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [changeRequest setHTTPMethod:@"POST"];
    [changeRequest setHTTPBody:postData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:changeRequest delegate:self startImmediately:YES];
    if (connection) {
        _receiveData = [[NSMutableData alloc] init];
        [connection start];
    }
    else
        [_myDelegate StopActivityView:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_myDelegate StopActivityView:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_myDelegate DoWithChangeResult:_receiveData];
    [_myDelegate StopActivityView:YES];
}


@end
