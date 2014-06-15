//
//  PlayRadio.m
//  FireFighting
//
//  Created by liang pengshuai on 14-5-11.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "PlayRadio.h"

@implementation PlayRadio
static SystemSoundID shake_sound_male_id = 0;

+ (void)playSound:(NSString *)soundType;
{
    NSString *path;
    if ([soundType isEqualToString:@"send"])
        path = [[NSBundle mainBundle] pathForResource:@"sendmsg" ofType:@"caf"];
    else path = [[NSBundle mainBundle] pathForResource:@"in" ofType:@"caf"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

@end
