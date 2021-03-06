//
//  RefreshInformationHttpRequest.h
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperHttpFunc.h"


@protocol RefreshHttpRequetResultDelegate <NSObject>

- (void)DoWithRereshResult: (NSData *)result;

@optional
- (void)StopRefreshInfoActivityView: (BOOL)isSucess;

@end

@interface RefreshInformationHttpRequest : SuperHttpFunc <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property(nonatomic, strong) NSMutableData *receiveData;
@property(nonatomic, assign) id<RefreshHttpRequetResultDelegate>myDelegate;

- (void)HttpRefreshWithPost: (NSData *)postData;

@end
