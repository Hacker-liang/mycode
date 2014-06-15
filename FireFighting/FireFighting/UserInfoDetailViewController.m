//
//  UserInfoDetailViewController.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "UserInfoDetailViewController.h"

@interface UserInfoDetailViewController ()

@end

@implementation UserInfoDetailViewController

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
    _detailLabel.text = _label;
    _detailContent.text = _content;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
