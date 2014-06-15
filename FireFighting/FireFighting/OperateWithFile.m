//
//  OperateWithFile.m
//  HttpTest
//
//  Created by liangpengshuai on 14-4-22.
//  Copyright (c) 2014年 liangpengshuai. All rights reserved.
//

#import "OperateWithFile.h"
#import "Base64.h"

@implementation OperateWithFile

+ (void)WriteDataToSandbox: (NSString *)filecontent fileName:(NSString *)filename

{
    
    NSData *base64Data = [Base64 base64Decode:filecontent];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentPath = [path objectAtIndex:0];
    NSString *writeToDic = [doucumentPath stringByAppendingPathComponent:@"AttachFile"];
    NSString *writetoPath = [writeToDic stringByAppendingPathComponent:filename];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    [filemanager createDirectoryAtPath:writeToDic withIntermediateDirectories:YES attributes:nil error:nil];
   [filemanager createFileAtPath:writetoPath contents:base64Data attributes:nil];

}



@end
