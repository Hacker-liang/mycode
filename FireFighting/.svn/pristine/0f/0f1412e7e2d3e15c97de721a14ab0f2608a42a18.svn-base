//
//  SocketTaskOperate.m
//  Socket
//
//  Created by liangpengshuai on 14-5-9.
//  Copyright (c) 2014年 liangpengshuai. All rights reserved.
//

#import "SocketTaskOperate.h"

@implementation SocketTaskOperate


+ (void)DistributeMsg:(NSData *)MsgFromServer
{
    NSDictionary *MsgDic = [OperateWithJson deCodewithJSON:MsgFromServer];
    NSString *MsgType = [MsgDic objectForKey:@"cmd"];
    if ([MsgType isEqualToString:@"newmsg"]) {
        NSMutableDictionary *insertToDBdic = [[NSMutableDictionary alloc] init];
        insertToDBdic = [[MsgDic objectForKey:@"msgcontent"] mutableCopy];
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        NSInteger intervalfrom1970 = [localeDate timeIntervalSince1970];
        [insertToDBdic setObject:[NSNumber numberWithDouble:intervalfrom1970] forKey:@"msgdate"];
        [insertToDBdic setObject:[NSNumber numberWithInt:0] forKey:@"msgstatus"];
        [OperateDatabase InsertChatlogToDatabase:insertToDBdic];
        //插入数据库
        //通知声音
        [PlayRadio playSound:@"receive"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateChatView" object:[MsgDic objectForKey:@"msgcontent"]];
    } else if ([MsgType isEqualToString:@"chatlog"]) {
        NSMutableArray *chatArray = [[NSMutableArray alloc] init];
        chatArray = [[MsgDic objectForKey:@"msgcontent"] mutableCopy];
        if ([chatArray count]>0) {
            [PlayRadio playSound:@"receive"];
            
            for (int i=0; i<[chatArray count]; i++) {
                NSMutableDictionary *insertToDBdic = [[NSMutableDictionary alloc] init];
                insertToDBdic = [[chatArray objectAtIndex:i] mutableCopy];
                [insertToDBdic setObject: [NSNumber numberWithLong:([[insertToDBdic objectForKey:@"msgdate"] doubleValue]+8*3600)] forKey:@"msgdate"];
                [insertToDBdic setObject:[NSNumber numberWithInt:0] forKey:@"msgstatus"];
                [OperateDatabase InsertChatlogToDatabase:insertToDBdic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateChatView" object:[chatArray objectAtIndex:i]];
            }
        }
        
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 1) {
//        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"查看"] ) {
//            NSLog(@"查看新消息");
//        }
//    }
    NSLog(@"click");
}

@end
