//
//  UserInfomation.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "UserInfomation.h"

static UserInfomation *userInfo;
@implementation UserInfomation

+ (UserInfomation *)shareUserInfo
{
    @synchronized (self)
    {
        if (userInfo == nil) {
            userInfo = [[self alloc] init];
        }
    }
    return userInfo;
}
@end
