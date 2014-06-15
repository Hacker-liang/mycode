//
//  LogInViewController.h
//  FireFighting
//
//  Created by liang pengshuai on 14-3-12.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "Name_Password.h"
#import "MainInterfaceTabBarViewController.h"
#import "LoginHttpRequest.h"
#import "OperateWithJson.h"
#import "OperateDatabase.h"
#import "UserInfomation.h"
#import "RefreshInformationHttpRequest.h"
#import "AboutMeViewController.h"
#import "SocketTaskOperate.h"
#import "SocketServer.h"

@interface LogInViewController : SuperViewController<UIApplicationDelegate, LoginHttpRequestResultDelegate, RefreshHttpRequetResultDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UITextField *nameContent;
@property (strong, nonatomic) IBOutlet UITextField *passwordContent;
- (IBAction)EnterAboutMe:(UIButton *)sender;

- (IBAction)requestEntering:(id)sender;
- (IBAction)TouchDownViewToHideKeyboard:(id)sender;

//- (void)willLaunchNextInterface:(NSString *)check_result;




@end
