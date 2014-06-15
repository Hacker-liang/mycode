//
//  OperateWithJson.h
//  FireFighting
//
//  Created by liang pengshuai on 14-4-19.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperateWithJson : NSObject

+ (NSData *)enCodeWithDictionary :(NSMutableDictionary *)encodeDictionary;
+ (NSMutableDictionary *)deCodewithJSON :(NSData *)json;

@end
