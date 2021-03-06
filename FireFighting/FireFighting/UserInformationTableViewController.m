//
//  UserInformationTableViewController.m
//  FireFighting
//
//  Created by liang pengshuai on 14-4-23.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "UserInformationTableViewController.h"

@interface UserInformationTableViewController ()
@property (strong, nonatomic) UserInfomation *userInfo;
@property (strong, nonatomic) RefreshInformationHttpRequest *refreshRequest;
@property (strong, nonatomic) UserInfoDetailViewController *userInfoDetailController;
@property (strong, nonatomic) UIImage *userphoto;

@end

static NSString *UserMainInfoCellIdentifier = @"usermaininfocell";
static NSString *UserDetailInfoCellIdentifier = @"userdetailinfocell";

@implementation UserInformationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.color = [UIColor blueColor];
    [_activityView setFrame:CGRectMake(130, 160, 60, 60)];
    [self.tableView addSubview:_activityView];
    _userInfo = [UserInfomation shareUserInfo];
    [self loadUserInfomation];
    UINib *mainNib = [UINib nibWithNibName:@"PersionalInfoMainTableViewCell" bundle:nil];
    UINib *detailNib = [UINib nibWithNibName:@"PersionalInfoDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:mainNib forCellReuseIdentifier:UserMainInfoCellIdentifier];
    [self.tableView registerNib:detailNib forCellReuseIdentifier:UserDetailInfoCellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterSettingDetailController) name:@"enterSettingDetailController" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RefreshControl:(UIBarButtonItem *)sender {
    [self RefreshRequest];
}

- (void)RefreshRequest {
    _refreshRequest = [[RefreshInformationHttpRequest alloc] init];
    _refreshRequest.myDelegate = self;
    [_activityView startAnimating];
    [_refreshRequest HttpRefreshWithPost:[self encodeRequestData]];
}

- (void)EnterSettingDetailController
{
    SettingDetailViewController *settingDetailController = [[SettingDetailViewController alloc] init];
    settingDetailController.photo = _userphoto;
    [self.navigationController pushViewController:settingDetailController animated:YES];
}

- (void)loadUserInfomation
{
    //从数据库读取信息，若数据库无此条记录，则将从网络上取消息
    if (![OperateDatabase getUserInfo]) {
        [self RefreshRequest];
    }
}

- (NSData *)encodeRequestData
{
    NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    [retDictionary setObject:@"refresh" forKey:@"change"];
    [retDictionary setObject:_userInfo.userNo forKey:@"userno"];
    NSData *retData = [OperateWithJson enCodeWithDictionary:retDictionary];
    return retData;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 70.0;
    else return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersionalInfoMainTableViewCell *maincell;
    PersionalInfoDetailTableViewCell *detailcell;
    switch (indexPath.row) {
        case 0:
            
            maincell = [tableView dequeueReusableCellWithIdentifier:UserMainInfoCellIdentifier forIndexPath:indexPath];
            maincell.userName.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
            maincell.userName.text = _userInfo.userName;
            maincell.userNo.text = _userInfo.userNo;
            if (_userInfo.accountType == 0)
                maincell.userType.text = @"高级权限";
            else
                maincell.userType.text = @"普通权限";
            if (_userInfo.userPhoto.length == 0) {
                _userphoto = [UIImage imageNamed:@"defaultphoto.png"];
                maincell.userImage.image = _userphoto;
                _userInfo.userPhoto = UIImageJPEGRepresentation(_userphoto, 1);
            }
            else {
                _userphoto = [UIImage imageWithData:_userInfo.userPhoto];
                maincell.userImage.image = _userphoto;
            }
            return maincell;
                break;
        case 1:
            detailcell = [tableView dequeueReusableCellWithIdentifier:UserDetailInfoCellIdentifier forIndexPath:indexPath];
            detailcell.detailLabel.text = @"部   门";
            detailcell.detailContent.text = _userInfo.department;
            detailcell.detailLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
            detailcell.accessoryType = UITableViewCellAccessoryDetailButton;
            detailcell.detailImage.image = [UIImage imageNamed:@"userdepartmentimage"];
            return detailcell;
                break;
        case 2:
            detailcell = [tableView dequeueReusableCellWithIdentifier:UserDetailInfoCellIdentifier forIndexPath:indexPath];
            detailcell.detailLabel.text = @"邮   箱";
            detailcell.detailContent.text = _userInfo.emailAddress;
            detailcell.detailLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
            detailcell.accessoryType = UITableViewCellAccessoryDetailButton;
            detailcell.detailImage.image = [UIImage imageNamed:@"useremailimage"];
            return detailcell;
                break;
        case 3:
            detailcell = [tableView dequeueReusableCellWithIdentifier:UserDetailInfoCellIdentifier forIndexPath:indexPath];
            detailcell.detailLabel.text = @"手机号";
            detailcell.detailContent.text = _userInfo.phoneNo;
            detailcell.detailLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
            detailcell.detailImage.image = [UIImage imageNamed:@"userphoneimage"];
            detailcell.detailImage.layer.cornerRadius = 15;
            detailcell.accessoryType = UITableViewCellAccessoryDetailButton;
            return detailcell;
                break;
        default:
            return nil;
                break;
    }

}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _userInfoDetailController = [[UserInfoDetailViewController alloc] init];
    switch (indexPath.row) {
        case 1:
            _userInfoDetailController.label = @"部 门";
            _userInfoDetailController.content = _userInfo.department;
            break;
        case 2:
            _userInfoDetailController.label = @"邮 箱";
            _userInfoDetailController.content = _userInfo.emailAddress;
            break;
        case 3:
            _userInfoDetailController.label = @"手 机";
            _userInfoDetailController.content= _userInfo.phoneNo;
            break;
        default:
            break;
    }
    _userInfoDetailController.navigationItem.title = @"详细信息";
    [self.navigationController pushViewController:_userInfoDetailController animated:YES];
}


#pragma mark - RefreshHttpRequetResultDelegate

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
    [self.tableView reloadData];
}

- (void)StopRefreshInfoActivityView:(BOOL)isSucess
{
    [_activityView stopAnimating];
    if (isSucess) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"更新成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"更新失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.tableView reloadData];
        [alert show];
    }
}

@end
