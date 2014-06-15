//
//  PostFileHttpRequest.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-1.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SuperHttpFunc.h"

@protocol PostFileHttpRequestResultDelegate

- (void)DoWithFilePostHttpResulat: (NSData *)resulatData;
@optional
- (void)StopActivityView: (BOOL)isSucess;


@end

@interface PostFileHttpRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSString *urlStr;
@property(nonatomic, strong) NSMutableData *receiveData;


@property(nonatomic, assign) id <PostFileHttpRequestResultDelegate>myDelegate;

- (void)HttpFilePostwithPost: (NSData *)fileContent;
@end
