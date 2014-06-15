//
//  FileDetailViewController.m
//  FireFighting
//
//  Created by liang pengshuai on 14-5-2.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "FileDetailViewController.h"

@interface FileDetailViewController ()

@end

@implementation FileDetailViewController

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
    self.navigationItem.title = @"文章详情";
    [self loadFileContent];
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

- (void)loadFileContent
{
    if (_isPostFileDetail && !_isUnpassFileDetail)
        _file = [OperateDatabase getPostFileContent:_file.posttime];
    else if(!_isPostFileDetail && !_isUnpassFileDetail)
        _file = [OperateDatabase getReceiveFileContent:_file.posttime];
    _fileLabel.text = _file.filelabel;
    _fileDetail.text = _file.filedetail;
    NSDate *postdate = [NSDate dateWithTimeIntervalSince1970:_file.posttime-8*3600];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd/MM/yyyy hh:mmaaa"];
    NSString *dateStr = [dateformatter stringFromDate:postdate];
    _posttime.text = dateStr;
    if (_isPostFileDetail || _isUnpassFileDetail) {
        if ([_file.todepartment isEqualToString:@"all"])
            _department.text = @"所有部门";
        else _department.text = _file.todepartment;
    } else {
        _department.text = _file.fromdepartment;
    }
    
    
    
   
}


@end












