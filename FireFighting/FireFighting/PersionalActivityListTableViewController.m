//
//  PersionalActivityListViewController.m
//  FireFighting
//
//  Created by liang pengshuai on 14-3-17.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "PersionalActivityListTableViewController.h"

@interface PersionalActivityListViewController ()

@property (strong, nonatomic) NSMutableArray *activityList;
@property (strong, nonatomic) ActivityHttpRequest *activityRequest;
@property (strong, nonatomic) UserInfomation *userInfo;

@end

@implementation PersionalActivityListViewController

static NSString *activityCellIndentifier = @"activitycell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"PersionalActivityListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:activityCellIndentifier];
    [self loadPullToRefresh];
    _userInfo = [UserInfomation shareUserInfo];
    [self updateUserList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPullToRefresh
{
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    __block PersionalActivityListViewController *tempSelf = self;
    [self.tableView addCustomPullToRefreshWithActionHandler:^{
        [tempSelf loadActivityInfoFromNet];
    }];

}

- (void)loadActivityInfoFromNet {
    if (!_activityRequest) {
        _activityRequest = [[ActivityHttpRequest alloc] init];
        _activityRequest.myDelegate = self;
    }
    [_activityRequest HttpActivitywithPost:[self encodeHttpRequest]];
}

- (NSData *)encodeHttpRequest
{
    NSData * retData = [[NSData alloc] init];
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"refreshactivity" forKey:@"request"];
    [requestDic setObject:_userInfo.userNo forKey:@"userno"];
    retData = [OperateWithJson enCodeWithDictionary:requestDic];
    return retData;
}

- (void)updateUserList
{
    if (!_activityList) {
        _activityList = [[NSMutableArray alloc] init];
    }
    _activityList = [[OperateDatabase getActivityList] mutableCopy];
    [self.tableView reloadData];
}

#pragma -tabview datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activityList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *activity = [[NSDictionary alloc] init];
    PersionActivityListTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:activityCellIndentifier forIndexPath:indexPath];
    activity = self.activityList[indexPath.row];
    activityCell.activityContent.text = [activity objectForKey:@"activitydetail"];
    NSDate *activitydate = [NSDate dateWithTimeIntervalSince1970:[[activity objectForKey:@"activitydate"] doubleValue]-8*3600];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd/MM/yyyy hh:mmaaa"];
    NSString *dateStr = [dateformatter stringFromDate:activitydate];
    activityCell.activityDate.text = dateStr;
    return activityCell;
}

#pragma -tableview delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.activityList);
    [OperateDatabase DeleteActivityList:[[[self.activityList objectAtIndex:indexPath.row] objectForKey:@"activitydate"] doubleValue]];
    [self.activityList removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - ActivityHttpRequestDelegate

- (void)DoWithActivityResult:(NSData *)resultData
{
    NSDictionary *requestDic = [[NSDictionary alloc] init];
    requestDic = [OperateWithJson deCodewithJSON:resultData];
    NSArray *listArray = [[NSArray alloc] init];
    listArray = [requestDic objectForKey:@"activitylist"];
    [OperateDatabase InsertActivityList:listArray];
    [self updateUserList];
    [self.tableView.pullToRefreshView stopAnimating];
}

@end
