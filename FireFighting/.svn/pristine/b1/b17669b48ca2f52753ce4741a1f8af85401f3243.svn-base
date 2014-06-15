//
//  PostFileDetailViewController.h
//  FireFighting
//
//  Created by liang pengshuai on 14-3-17.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "SuperViewController.h"
#import "UserInfomation.h"
#import "OperateDatabase.h"
#import "OperateWithJson.h"
#import "PostFileHttpRequest.h"

@interface PostFileDetailViewController : SuperViewController <UIAlertViewDelegate, PostFileHttpRequestResultDelegate>
@property (strong, nonatomic) IBOutlet UITextField *fileLabel;
@property (strong, nonatomic) IBOutlet UITextView *fileDetail;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *departmentSegment;
- (IBAction)ChoseDepartment:(UISegmentedControl *)sender;
- (IBAction)PostFile:(UIButton *)sender;

@end
