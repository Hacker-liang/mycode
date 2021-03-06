//
//  FileReceiveTableViewCell.h
//  FireFighting
//
//  Created by liang pengshuai on 14-3-13.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol checkFileDeleagte

- (void)checkFile:(NSString *)chectStr;

@end

@interface FileReceiveTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *fileContentTextField;
@property (strong, nonatomic) IBOutlet UILabel *filePostUser;
@property (strong, nonatomic) IBOutlet UILabel *filePostTime;
@property (assign, nonatomic) id<checkFileDeleagte> myDelegate;
- (IBAction)PassBtn:(UIButton *)sender;

- (IBAction)noPassBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *pass;
@property (strong, nonatomic) IBOutlet UIButton *nopass;

@end
