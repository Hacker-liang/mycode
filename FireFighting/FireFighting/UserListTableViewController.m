 //
//  UserListTableViewController.m
//  FireFighting
//
//  Created by liang pengshuai on 14-3-17.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "UserListTableViewController.h"

@interface UserListTableViewController ()
@property (strong, nonatomic) ChatViewController *chatViewController;
@property (copy, nonatomic) NSMutableArray *userList;
@property (strong, nonatomic) UserInfomation *userInfo;
@property (strong, nonatomic) RefreshInformationHttpRequest *refreshUserInfoRequset;

@end

@implementation UserListTableViewController

static NSString *userListCell = @"userlistcellidentifier";

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
    UINib *nib = [UINib nibWithNibName:@"UserListTableViewCell" bundle:nil];
    [self.userListTableView registerNib:nib forCellReuseIdentifier:userListCell];
    _userInfo = [UserInfomation shareUserInfo];
    [self updateUserList];
    [self loadPullToRefresh];
    NSLog(@"%lf",self.userListTableView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.userListTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserList) name:@"updateChatView" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateChatView" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadPullToRefresh
{
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.userListTableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.userListTableView.contentInset = insets;
        self.userListTableView.scrollIndicatorInsets = insets;
    }
    __block UserListTableViewController *tempSelf = self;
    [self.userListTableView addCustomPullToRefreshWithActionHandler:^{
        [tempSelf loadAllUsersInfo];
    }];
}

- (void)loadAllUsersInfo
{
    [self.userListTableView.pullToRefreshView startAnimating];
    _refreshUserInfoRequset = [[RefreshInformationHttpRequest alloc] init];
    _refreshUserInfoRequset.myDelegate = self;
    [_refreshUserInfoRequset HttpRefreshWithPost:[self encodeRequestMsg]];
}

- (NSData *)encodeRequestMsg
{
    NSData *retData = [[NSData alloc] init];
    NSMutableDictionary *RequestDic = [[NSMutableDictionary alloc] init];
    [RequestDic setObject:@"refreshall" forKey:@"change"];
    [RequestDic setObject:_userInfo.userNo forKey:@"userno"];
    retData = [OperateWithJson enCodeWithDictionary:RequestDic];
    return retData;
}

- (void)updateUserList
{
    if (!_userList) {
        _userList = [[NSMutableArray alloc] init];
    }
    _userList = [OperateDatabase getOtherUserInfo];
    [self.userListTableView reloadData];
}

#pragma -tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_userList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userListCell forIndexPath:indexPath];
    cell.username.text = [_userList[indexPath.row]objectForKey:@"username"] ;
    cell.userNo.text = [_userList[indexPath.row]objectForKey:@"userno"];
    if ([[_userList[indexPath.row] objectForKey:@"userphoto"] length] != 0)
        cell.userPhoto.image = [UIImage imageWithData:[_userList[indexPath.row] objectForKey:@"userphoto"]];
    else cell.userPhoto.image = [UIImage imageNamed:@"defaultphoto.png"];
    
    cell.userdepartment.text = [_userList[indexPath.row]objectForKey:@"department"];
    if ([OperateDatabase getChatIsUnRead:[_userList[indexPath.row]objectForKey:@"userno"]])
        cell.isUnReadMesLabel.hidden = NO;
    else
        cell.isUnReadMesLabel.hidden = YES;
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma -tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _chatViewController = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    _chatViewController.chatWith = [self.userList[indexPath.row] objectForKey:@"username"];
    _chatViewController.otherImage = [UIImage imageWithData:[[_userList objectAtIndex:indexPath.row] objectForKey:@"userphoto"]];
    _chatViewController.myImage = [UIImage imageWithData:_userInfo.userPhoto];
    _chatViewController.otherUserID = [self.userList[indexPath.row] objectForKey:@"userno"];
    [self.navigationController pushViewController:_chatViewController animated:YES];
}

- (void)DoWithRereshResult:(NSData *)result
{
    NSDictionary *retDic = [OperateWithJson deCodewithJSON:result];
    [OperateDatabase deleteAllOldElement:@"otheruserinfo"];
    if ([[retDic objectForKey:@"refreshallresult"] count] != 0) {
    [OperateDatabase InsertOtherUserInfoToDatabase:[retDic objectForKey:@"refreshallresult"]];
    }
    [self updateUserList];
    [self.userListTableView.pullToRefreshView stopAnimating];
}

- (void)StopRefreshInfoActivityView:(BOOL)isSucess
{
    
}










@end
