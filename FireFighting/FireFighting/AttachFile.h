//
//  AttachFile.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-5.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttachFile : NSObject

@property (strong, nonatomic) NSString *attachfileType; //offic:文档  image:图片  pdf：pdf  html：html
@property (strong, nonatomic) NSString *attachfileLabel;
@property (assign) NSInteger attachfileStatus; //是否已经下载 0代表未下载，1代表已经下载

@end
