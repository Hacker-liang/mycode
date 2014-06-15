//
//  RefreshInformationHttpRequest.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "RefreshInformationHttpRequest.h"

@implementation RefreshInformationHttpRequest

- (void)HttpRefreshWithPost: (NSData *)postData
{
     NSString* urlStr = [NSString stringWithFormat:@"%@UpdateUserInfoServlet",commonUrl];
    NSURL *refreshURL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *refreshRequest = [[NSMutableURLRequest alloc] initWithURL:refreshURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [refreshRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [refreshRequest setHTTPMethod:@"POST"];
    [refreshRequest setHTTPBody:postData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:refreshRequest delegate:self startImmediately:YES];
    if (connection) {
        _receiveData = [[NSMutableData alloc] init];
        [connection start];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
    [_myDelegate StopRefreshInfoActivityView:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_myDelegate DoWithRereshResult:_receiveData];
    [_myDelegate StopRefreshInfoActivityView:YES];
}

@end
