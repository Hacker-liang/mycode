//
//  FileContent.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-2.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileContent : NSObject
@property (strong, nonatomic) NSString *userno;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *todepartment;
@property (strong, nonatomic) NSString *fromdepartment;
@property (assign) long posttime;
@property (assign) int filestatus;
@property (strong, nonatomic) NSString *filelabel;
@property (strong, nonatomic) NSString *filedetail;

@end
