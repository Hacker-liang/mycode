//
//  OperateWithJson.m
//  FireFighting
//
//  Created by liang pengshuai on 14-4-19.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "OperateWithJson.h"

@implementation OperateWithJson

+ (NSData *)enCodeWithDictionary:(NSMutableDictionary *)encodeDictionary
{
    NSData *retData = [NSJSONSerialization dataWithJSONObject:encodeDictionary options:NSJSONWritingPrettyPrinted error:nil];
    return retData;
}

+ (NSMutableDictionary *)deCodewithJSON:(NSData *)json
{
    NSMutableDictionary *retDictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];
    return retDictionary;
}


@end
