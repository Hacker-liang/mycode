//
//  FilePostViewController.h
//  FireFighting
//
//  Created by liang pengshuai on 14-3-15.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "FilePostTableViewCell.h"
#import "PostFileDetailViewController.h"
#import "SVPullToRefresh.h"
#import "PostFileHttpRequest.h"
#import "UserInfomation.h"
#import "OperateDatabase.h"
#import "OperateWithJson.h"
#import "FileContent.h"
#import "FileDetailViewController.h"

@protocol presentnewfileview

- (void)CreatNewFileViewController:(UIViewController *)viewController;

@end

@interface FilePostViewController : SuperViewController<UITableViewDataSource, UITableViewDelegate, PostFileHttpRequestResultDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentButton;

@property (strong, nonatomic) IBOutlet UITableView *FilePostTableView;

- (IBAction)FileSegment:(UISegmentedControl *)sender;
@property (assign, nonatomic)id<presentnewfileview>myDelegate;

@end
