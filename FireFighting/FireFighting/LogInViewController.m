//
//  LogInViewController.m
//  FireFighting
//
//  Created by liang pengshuai on 14-3-12.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//
#define ADMINER_PERMIT 0;
#define SECOND_ADMINER_PERMIT 1;
//#define NETWORDERROR = @"networkerror"
#import "LogInViewController.h"

@interface LogInViewController ()

@property (strong, nonatomic) MainInterfaceTabBarViewController *mainTabBarViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) LoginHttpRequest *loginHttpRequest;
@property (strong, nonatomic) RefreshInformationHttpRequest *refreshHttpRequest;
@property (strong, nonatomic) UserInfomation *userInfo;

@end

//static NSString *NETWORDERROR = @"networkerror";
//static NSString *ILLEGAL = @"illegal";

@implementation LogInViewController

- (void)viewDidLoad
{
    _loginHttpRequest = [[LoginHttpRequest alloc] init];
    _loginHttpRequest.myDelegate = self;
     _userInfo = [UserInfomation shareUserInfo];
}
- (IBAction)EnterAboutMe:(UIButton *)sender {
    AboutMeViewController *aboutViewController = [[AboutMeViewController alloc] init];
    [self presentViewController:aboutViewController animated:YES completion:nil];
}

- (IBAction)requestEntering:(id)sender {
    
    Name_Password *name_password = [[Name_Password alloc]init];
    name_password.userName = _nameContent.text;
    name_password.userPassword = _passwordContent.text;
   // NSString *check_result = [name_password nameandPasswordCheck:name_password.userName checkPassword:name_password.userPassword];
    UIStoryboard *currentStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _tabBarController = [currentStoryboard instantiateViewControllerWithIdentifier:@"OperationStoryboard"];
    _userInfo.userNo = _nameContent.text;
    _userInfo.password = _passwordContent.text;
    [self presentViewController:_tabBarController animated:YES completion:nil];
    //[_loginHttpRequest HttpLogintwithPost:[self encodeWithInput]];
    [_activityView startAnimating];

}

- (IBAction)TouchDownViewToHideKeyboard:(id)sender {
    [self.nameContent resignFirstResponder];
    [self.passwordContent resignFirstResponder];
}

- (NSData *)encodeWithInput
{
    NSString *username = _nameContent.text;
    NSString *userpassword = _passwordContent.text;
    NSMutableDictionary *loginDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    [userDictionary setObject:username forKey:@"username"];
    [userDictionary setObject:userpassword forKey:@"userpassword"];
    [loginDictionary setObject:userDictionary forKey:@"login"];
    NSData *retData = [OperateWithJson enCodeWithDictionary:loginDictionary];
    return retData;
}

- (NSData *)encodeWithRefreshQuest
{
    NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    [retDictionary setObject:@"refresh" forKey:@"change"];
    [retDictionary setObject:_userInfo.userNo forKey:@"userno"];
    NSData *retData = [OperateWithJson enCodeWithDictionary:retDictionary];
    return retData;
}

//根据返回来的判断信息来指定view controller 的加载。
- (void)loadUserInfo
{
    _refreshHttpRequest = [[RefreshInformationHttpRequest alloc] init];
    _refreshHttpRequest.myDelegate = self;
    [_refreshHttpRequest HttpRefreshWithPost:[self encodeWithRefreshQuest]];
}

- (void)willLaunchNextInterface
{
    
    if (_userInfo.accountType == 0) {
        [self presentViewController:_tabBarController animated:YES completion:nil];
    } else if(_userInfo.accountType == 1) {
        UITabBar *basicControllerTabBar = _tabBarController.tabBar;
        UITabBarItem *basicItem = [basicControllerTabBar.items objectAtIndex:3];
        basicItem.enabled = NO;
        [self presentViewController:_tabBarController animated:YES completion:nil];
    }
    SocketServer *socketServer = [SocketServer shareSocketServer];
    [socketServer connectToServer];
}

- (void)HideTabbar
{
    _tabBarController.tabBar.hidden = YES;
}

- (void)ShowTabbar
{
    _tabBarController.tabBar.hidden = NO;
}


#pragma mark- LoginHttpRequestResultDelegate

- (void)DoWithLoginHttpResulat:(NSData *)resultData
{
    NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    retDictionary = [OperateWithJson deCodewithJSON:resultData];
    resultDictionary = [retDictionary objectForKey:@"login"];
    id result = [resultDictionary objectForKey:@"checkresult"];
    id acount = [resultDictionary objectForKey:@"accountType"];
    if ([result isEqualToString:@"ok"]) {
        int accounttype = [acount intValue];
        _userInfo.userNo = _nameContent.text;
        _userInfo.password = _passwordContent.text;
        _userInfo.accountType = accounttype;
        [self loadUserInfo];
    } else {
        [_activityView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)StopLoginActivityView:(BOOL)isSucess
{
    [_activityView stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络错误,请重试" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark- RefreshHttpRequetResultDelegate

- (void)DoWithRereshResult:(NSData *)result
{
    NSDictionary *retDic = [OperateWithJson deCodewithJSON:result];
    NSDictionary *userInfoDic = [retDic objectForKey:@"refreshresult"];
    _userInfo.userNo = [userInfoDic objectForKey:@"userno"];
    _userInfo.userName = [userInfoDic objectForKey:@"username"];
    _userInfo.accountType = [[userInfoDic objectForKey:@"accounttype"] intValue];
    _userInfo.department = [userInfoDic objectForKey:@"department"];
    _userInfo.emailAddress = [userInfoDic objectForKey:@"emailaddress"];
    _userInfo.phoneNo = [userInfoDic objectForKey:@"phonenumber"];
    if ([userInfoDic objectForKey:@"userphoto"] != NULL) {
        _userInfo.userPhoto = [Base64 base64Decode:[userInfoDic objectForKey:@"userphoto"]];
    }
    [OperateDatabase InsertUserInfoToDatabase];
    [_activityView stopAnimating];
    [self willLaunchNextInterface];
}

- (void)StopRefreshInfoActivityView:(BOOL)isSucess
{
   
}



@end


















