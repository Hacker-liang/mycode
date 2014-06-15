//
//  AttachFileDownloadTableViewCell.m
//  FireFighting
//
//  Created by liang pengshuai on 14-5-4.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "AttachFileDownloadTableViewCell.h"

@implementation AttachFileDownloadTableViewCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (IBAction)PreviewFile:(UIButton *)sender {
    [_myDelegate PreviewAttachfile:_attachFileName];
}


- (IBAction)DownLoadAttachFile:(UIButton *)sender {
    [_myDelegate DownloadAttachfile:_attachFileName];
}
@end
