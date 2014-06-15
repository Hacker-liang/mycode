//
//  SettingDetailViewController.h
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperateWithJson.h"
#import "ChangeInfoHttpRequest.h"
#import "SuperViewController.h"
#import "UserInfomation.h"
#import "Base64.h"
#import "OperateDatabase.h"

@interface SettingDetailViewController : SuperViewController <ChangeHttpRequestResultDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userphoto;
@property (weak, nonatomic) IBOutlet UILabel *EmailLabel;
@property (strong, nonatomic) IBOutlet UITextField *EmailContent;
@property (weak, nonatomic) IBOutlet UILabel *PhoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *PhoneContent;
@property (weak, nonatomic) IBOutlet UILabel *PasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *PasswordContent;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SettingSegmentBtn;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordContent;
- (IBAction)SettingSegement:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
- (IBAction)SaveChanges:(UIButton *)sender;

- (IBAction)UpdatePhoto:(UIButton *)sender;
@property (strong, nonatomic) UIImage *photo;
@end
