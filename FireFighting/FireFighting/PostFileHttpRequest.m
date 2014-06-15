//
//  PostFileHttpRequest.m
//  FireFighting
//
//  Created by liang pengshuai on 14-5-1.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "PostFileHttpRequest.h"

@implementation PostFileHttpRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) HttpFilePostwithPost:(NSData *)fileContent
{
    NSString* urlStr = [NSString stringWithFormat:@"%@FilePostServlet", commonUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *postFileReques = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [postFileReques addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [postFileReques setHTTPMethod:@"POST"];
    [postFileReques setHTTPBody:fileContent];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:postFileReques delegate:self startImmediately:YES];
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
    NSLog(@"发送文章收到回应");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_myDelegate DoWithFilePostHttpResulat:_receiveData];
    
}

@end

