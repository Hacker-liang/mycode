//
//  FileReceiveTableViewCell.m
//  FireFighting
//
//  Created by liang pengshuai on 14-3-13.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "FileReceiveTableViewCell.h"

@implementation FileReceiveTableViewCell



- (IBAction)PassBtn:(UIButton *)sender {
    [_myDelegate checkFile:@"pass"];
}

- (IBAction)noPassBtn:(UIButton *)sender {
    [_myDelegate checkFile:@"nopass"];
}


@end
