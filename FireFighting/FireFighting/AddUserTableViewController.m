//
//  AddUserTableViewController.m
//  FireFighting
//
//  Created by liang pengshuai on 14-5-12.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "AddUserTableViewController.h"
#import "UserInfomation.h"

@interface AddUserTableViewController ()
@property (strong, nonatomic) UserInfomation *userInfo;
@property (strong, nonatomic) RefreshInformationHttpRequest *refereshRequest;

@end

@implementation AddUserTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"AddUserTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"addusercell"];
    self.navigationItem.title = @"新增用户信息";
//    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
//    [rightButton setTitle:@"提交" forState:UIControlStateNormal];   // 设置风格
//    //[rightButton addTarget:self action:@selector(searchprogram)forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem= rightItem;
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(submitBtn)];
    barbtn.title = @"提交";
    self.navigationItem.rightBarButtonItem=barbtn;

    _userInfo = [UserInfomation shareUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitBtn
{
    if ([self checkInput]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认增加此用户?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (BOOL)checkInput
{
    for (int i= 0; i<3; i++) {
        AddUserTableViewCell *cell = (AddUserTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSLog(@"%@",cell.detaillabel.text);
        if (cell.detaillabel.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@不能为空",cell.titlelabel.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
   
}

- (void)submitRequest
{
    if (!_refereshRequest) {
        _refereshRequest = [[RefreshInformationHttpRequest alloc] init];
        _refereshRequest.myDelegate = self;
    }
    [_refereshRequest HttpRefreshWithPost:[self encodeWithInput]];
}

- (NSData *)encodeWithInput
{
    NSData *retData = [[NSData alloc] init];
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    AddUserTableViewCell *cell = [[AddUserTableViewCell alloc] init];
    cell = (AddUserTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSLog(@"%@", cell.detailTextLabel.text);
    [requestDic setObject:cell.detaillabel.text forKey:@"userno"];
    cell = (AddUserTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [requestDic setObject:cell.detaillabel.text forKey:@"password"];
    cell = (AddUserTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [requestDic setObject:cell.detaillabel.text forKey:@"username"];
    [requestDic setObject:_userInfo.department forKey:@"department"];
    [requestDic setObject:@"adduser" forKey:@"change"];
    retData = [OperateWithJson enCodeWithDictionary:requestDic];
    return retData;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self submitRequest];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addusercell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.titlelabel.text = @"用户名:";
            break;
        case 1:
            cell.titlelabel.text = @"密   码:";
            break;
        case 2:
            cell.titlelabel.text = @"姓   名:";
            break;
        case 3:
            cell.titlelabel.text = @"部   门:";
            cell.detaillabel.enabled = NO;
            cell.detaillabel.text = _userInfo.department;
            break;
        default:
            break;
    }
    cell.titlelabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    return cell;
}

#pragma mark - RefreshHttpRequetResultDelegate
- (void)DoWithRereshResult:(NSData *)result
{
    NSDictionary *retDic = [[NSDictionary alloc] init];
    retDic = [OperateWithJson deCodewithJSON:result];
    UIAlertView *alert;
    if ([[retDic objectForKey:@"addResult"] boolValue]) {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"操作成功" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    } else alert = [[UIAlertView alloc] initWithTitle:@"" message:@"操作失败，用户名可能已存在" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)StopRefreshInfoActivityView:(BOOL)isSucess
{
    
}




@end
