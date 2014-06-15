//
//  ChangeInfoHttpRequest.h
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperHttpFunc.h"


@protocol ChangeHttpRequestResultDelegate

@optional
- (void)StopActivityView: (BOOL)isSucess;
- (void)DoWithChangeResult: (NSData *)changeResult;

@end

@interface ChangeInfoHttpRequest : SuperHttpFunc <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

- (void)ChangeInfoHttpRequestWithPost: (NSData *)postData;
@property(nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, assign)id <ChangeHttpRequestResultDelegate>myDelegate;

@end
