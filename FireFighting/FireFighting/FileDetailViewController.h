//
//  FileDetailViewController.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-2.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileContent.h"
#import "OperateDatabase.h"

@interface FileDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *fileLabel;
@property (strong, nonatomic) IBOutlet UILabel *department;
@property (strong, nonatomic) IBOutlet UITextView *fileDetail;
@property (strong, nonatomic) IBOutlet UILabel *posttime;
@property (strong, nonatomic) FileContent *file;
@property (assign) BOOL isPostFileDetail;
@property (assign) BOOL isUnpassFileDetail;

@end
