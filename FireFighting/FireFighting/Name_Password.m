//
//  Name_Password.m
//  FireFighting
//
//  Created by liang pengshuai on 14-3-12.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "Name_Password.h"

@implementation Name_Password

static NSString *ADMINER_PERMIT = @"adminer_permit";
static NSString *SECOND_ADMINER_PERMIT = @"second_adminer_permit";
static NSString *NETWORDERROR = @"networkerror";
static NSString *ILLEGAL = @"illegal";

- (NSString *) nameandPasswordCheck:(NSString *)username checkPassword:(NSString *)password
{
    
    //return ADMINER_PERMIT;
    return SECOND_ADMINER_PERMIT;
}

@end
