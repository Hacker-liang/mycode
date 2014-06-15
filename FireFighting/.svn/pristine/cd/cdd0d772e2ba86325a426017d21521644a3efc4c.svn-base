//
//  ActivityHttpRequest.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-11.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperHttpFunc.h"

@protocol ActivityHttpRequestDelegate

@optional
- (void)StopLoginActivityView: (BOOL)isSucess;
- (void)DoWithActivityResult:(NSData *)resultData;

@end


@interface ActivityHttpRequest : SuperHttpFunc <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSMutableData *receiveData;


@property(nonatomic, assign) id <ActivityHttpRequestDelegate>myDelegate;

- (void)HttpActivitywithPost: (NSData *)userNO;

@end