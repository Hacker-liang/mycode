//
//  UserListTableViewController.h
//  FireFighting
//
//  Created by liang pengshuai on 14-3-17.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "SuperViewController.h"
#import "UserListTableViewCell.h"
#import "ChatViewController.h"
#import "MainInterfaceTabBarViewController.h"
#import "SVPullToRefresh.h"
#import "RefreshInformationHttpRequest.h"
#import "OperateDatabase.h"
#import "OperateWithJson.h"
#import "UserInfomation.h"

@interface UserListTableViewController : SuperViewController <RefreshHttpRequetResultDelegate>
@property (strong, nonatomic) IBOutlet UITableView *userListTableView;

@end
