//
//  SettingDetailViewController.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "SettingDetailViewController.h"

@interface SettingDetailViewController ()
@property (strong, nonatomic) ChangeInfoHttpRequest *changeRequest;
@property (strong, nonatomic) UserInfomation *userInfo;
@property (strong, nonatomic) NSString *tempEmail;
@property (strong, nonatomic) NSString *tempPhone;
@property (strong, nonatomic) NSData *tempphotodata;
@property (strong, nonatomic) NSString *temppassword;

@end

@implementation SettingDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userInfo = [UserInfomation shareUserInfo];
    _PasswordLabel.hidden = YES;
    _PasswordContent.hidden = YES;
    _confirmPasswordLabel.hidden = YES;
    _confirmPasswordContent.hidden = YES;
    _activityView.hidden = YES;
    self.navigationItem.title = @"设置";
    _userphoto.image = _photo;
    _tempphotodata = _userInfo.userPhoto;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)UpdatePhoto:(UIButton *)sender {
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=sourceType;
    [self presentViewController:picker animated:YES completion:nil];

}

- (IBAction)SettingSegement:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        _PasswordLabel.hidden = YES;
        _PasswordContent.hidden = YES;
        _confirmPasswordLabel.hidden = YES;
        _confirmPasswordContent.hidden = YES;
        _EmailLabel.hidden = NO;
        _EmailContent.hidden = NO;
        _PhoneLabel.hidden = NO;
        _PhoneContent.hidden = NO;

    }else {
        _PasswordLabel.hidden = NO;
        _PasswordContent.hidden = NO;
        _confirmPasswordLabel.hidden = NO;
        _confirmPasswordContent.hidden = NO;
        _EmailLabel.hidden = YES;
        _EmailContent.hidden = YES;
        _PhoneLabel.hidden = YES;
        _PhoneContent.hidden = YES;
    }
}

- (IBAction)SaveChanges:(UIButton *)sender
{
    if ([self CheckInput]) {
        _activityView.hidden = NO;
        [_activityView startAnimating];
        _changeRequest = [[ChangeInfoHttpRequest alloc] init];
        _changeRequest.myDelegate = self;
        [_changeRequest ChangeInfoHttpRequestWithPost:[self encodeWithInput]];
    }
}

- (NSData *)encodeWithInput
{
     NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    if (![_EmailContent.text isEqualToString:@""])
        _tempEmail = _EmailContent.text;
    else _tempEmail = _userInfo.emailAddress;
    if (![_PhoneContent.text isEqualToString:@""])
        _tempPhone = _PhoneContent.text;
    else _tempPhone = _userInfo.phoneNo;
    [retDictionary setObject:@"changecontact" forKey:@"change"];
    [retDictionary setObject:_userInfo.userNo forKey:@"userno"];
    [retDictionary setObject:_tempEmail forKey:@"newemail"];
    [retDictionary setObject:_tempPhone forKey:@"newphone"];
    [retDictionary setObject:_temppassword forKey:@"newpassword"];
    [retDictionary setObject:[Base64 base64Encode:_tempphotodata] forKey:@"newphoto"];
    NSData *retData = [OperateWithJson enCodeWithDictionary:retDictionary];
    return retData;
}

- (BOOL)CheckInput
{
    if (![_PasswordContent.text isEqualToString:@""]) {
        if ([_confirmPasswordContent.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认密码不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            _temppassword = _userInfo.password;
            [alert show];
            return NO;
        }else if (![_confirmPasswordContent.text isEqualToString:_PasswordContent.text]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"两次输入不一致" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            _temppassword = _userInfo.password;
            return NO;
        }else {
            _temppassword = _PasswordContent.text;
            return YES;
        }
    }else if ([_PasswordContent.text isEqualToString:@""] &&  [_confirmPasswordContent.text isEqualToString:@""]) {
        _temppassword = _userInfo.password;
        return YES;
    }
    _temppassword = _userInfo.password;
    return NO;
}

- (void)updateUserInfoToDatabase
{
    _userInfo.emailAddress = _tempEmail;
    _userInfo.phoneNo = _tempPhone;
    _userInfo.userPhoto = _tempphotodata;
    _userInfo.password = _temppassword;
    [OperateDatabase InsertUserInfoToDatabase];
}

#pragma mark - ChangeHttpRequestResultDelegate

- (void)StopActivityView:(BOOL)isSucess
{
    UIAlertView *alert;
    if (isSucess) {
        [_activityView stopAnimating];
        _activityView.hidden = YES;
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)DoWithChangeResult:(NSData *)changeResult
{
    NSDictionary *updateDic = [OperateWithJson deCodewithJSON:changeResult];
    id result = [updateDic objectForKey:@"updateresult"];
    if ([result boolValue]) {
        [self updateUserInfoToDatabase];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    _userphoto.image =[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData *phdata = UIImageJPEGRepresentation(_userphoto.image, 0.05);
    _tempphotodata = phdata;
}


@end



























