//
//  UserInfomation.h
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfomation : NSObject

@property (strong, nonatomic)NSString *userName;
@property (strong, nonatomic)NSString *userNo;
@property (strong, nonatomic)NSString *password;
@property (nonatomic)int accountType;
@property (strong, nonatomic)NSString *department;
@property (strong, nonatomic)NSString *phoneNo;
@property (strong, nonatomic)NSString *emailAddress;
@property (strong, nonatomic)NSData *userPhoto;

+ (UserInfomation *)shareUserInfo;

@end
