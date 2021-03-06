//
//  AttachFileDownloadTableViewCell.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-4.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttachFileDownloadDelegate

- (void)DownloadAttachfile:(NSString *)fileName;
- (void)PreviewAttachfile:(NSString *)fileName;

@end

@interface AttachFileDownloadTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *attachFileImage;

@property (strong, nonatomic) IBOutlet UILabel *attachFilelabel;
@property (assign, nonatomic) id <AttachFileDownloadDelegate> myDelegate;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
@property (assign) BOOL isDownload;
@property (strong, nonatomic) NSString *attachFileName;
@property (strong, nonatomic) IBOutlet UIButton *isDownloadBtn;
- (IBAction)PreviewFile:(UIButton *)sender;

- (IBAction)DownLoadAttachFile:(UIButton *)sender;


@end
