//
//  PlayRadio.h
//  FireFighting
//
//  Created by liang pengshuai on 14-5-11.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <AudioToolbox/AudioToolbox.h>
@interface PlayRadio : NSObject

+ (void)playSound:(NSString *)soundType;

@end
