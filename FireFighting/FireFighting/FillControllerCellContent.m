//
//  FillControllerCellContent.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-22.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "FillControllerCellContent.h"

@implementation FillControllerCellContent

+ (NSDictionary *)FillControllerCellContent
{
    NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *postFileDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *receiveFileDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *downloadFileDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *persionalWorkDictionary = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *countDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *basicArray = [[NSMutableArray alloc] init];
    NSMutableArray *advanceArray = [[NSMutableArray alloc] init];
    //NSMutableDictionary *advance_trend_dictionary = [[NSMutableDictionary alloc] init];


    [postFileDictionary setObject:@"postfile.png" forKey:@"picture"];
    [postFileDictionary setObject:@"发文管理" forKey:@"label"];
    [receiveFileDictionary setObject:@"receivefile.png" forKey:@"picture"];
    [receiveFileDictionary setObject:@"收文管理" forKey:@"label"];
    [downloadFileDictionary setObject:@"downloadfile.png" forKey:@"picture"];
    [downloadFileDictionary setObject:@"下载文件" forKey:@"label"];
    [persionalWorkDictionary setObject:@"personactivity.png" forKey:@"picture"];
    [persionalWorkDictionary setObject:@"活动信息" forKey:@"label"];
//    [countDictionary setObject:@"countfile.png" forKey:@"picture"];
//    [countDictionary setObject:@"统计功能" forKey:@"label"];
    [basicArray insertObject:postFileDictionary atIndex:0];
    [basicArray insertObject:receiveFileDictionary atIndex:1];
    [basicArray insertObject:downloadFileDictionary atIndex:2];
    [basicArray insertObject:persionalWorkDictionary atIndex:3];
    //[basicArray insertObject:countDictionary atIndex:4];
    [retDictionary setObject:basicArray forKey:@"basiccontroller"];
    [retDictionary setObject:advanceArray forKey:@"advancecontroller"];
    return retDictionary;
}

@end
