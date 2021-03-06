//
//  OperateDatabase.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-24.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "OperateDatabase.h"

@implementation OperateDatabase

static sqlite3 *database;
static NSString *mainDatabaseName = @"user.sqlite";
//static sqlite3_stmt *statement;
+ (NSString *)getUserDatabasePath: (NSString *)userNo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userDatabaseName = [userNo stringByAppendingFormat:@".sqlite"];
    NSString *userDocumentPath =  [documentsDirectory stringByAppendingPathComponent:userDatabaseName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:userDocumentPath])
        [fileManager createDirectoryAtPath:userDocumentPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return userDocumentPath;
}

+ (NSString *)getMainDatabasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *retDiectory = [documentsDirectory stringByAppendingPathComponent:mainDatabaseName];
    return retDiectory;
}

+ (NSString *)getUserDatabasePath
{
    UserInfomation *userInfo = [UserInfomation shareUserInfo];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userPath = [NSString stringWithFormat:@"%@.sqlite", userInfo.userNo];
    NSString *retDiectory = [documentsDirectory stringByAppendingPathComponent:userPath];
    return retDiectory;
}

+ (BOOL)OpenDatabase: (NSString *)databasePath
{
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Fail to open database");
        return NO;
    }
    return YES;
}

+ (void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库操作数据失败!");
    }
}

+ (BOOL)getUserInfo
{
    UserInfomation *userInfo = [UserInfomation shareUserInfo];
    sqlite3_stmt *stmt;
    NSString *createUserInfoTable = [NSString stringWithFormat:@"create table if not exists userinfo(userno text primary key, username text, userphoto text, accounttype integer, department text, emailaddress text, phone text)"];
    NSString *mainDatabasePath = [OperateDatabase getMainDatabasePath];
    NSString *selectInfo = [NSString stringWithFormat:@"select * from userinfo where userno = '%@'",userInfo.userNo];
   //为了测试使用固定用户名
    //NSString *selectInfo = [NSString stringWithFormat:@"select * from userinfo where userno = 'heheceo'"];
    BOOL openResult = [OperateDatabase OpenDatabase:mainDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createUserInfoTable];
        if (sqlite3_prepare_v2(database, [selectInfo UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *userno = (char *)sqlite3_column_text(stmt, 0);
                userInfo.userNo = [[NSString alloc] initWithUTF8String:userno];
                char *username = (char *)sqlite3_column_text(stmt, 1);
                if (username != NULL)
                    userInfo.userName = [[NSString alloc] initWithUTF8String:username];
                else
                    userInfo.userName = @"";
                char *userphoto = (char *)sqlite3_column_text(stmt, 2);
                userInfo.userPhoto = [Base64 base64Decode:[[NSString alloc] initWithUTF8String:userphoto]];
                userInfo.accountType = sqlite3_column_int(stmt, 3);
                char *department = (char *)sqlite3_column_text(stmt, 4);
                if (department != NULL)
                    userInfo.department = [[NSString alloc] initWithUTF8String:department];
                else
                    userInfo.department = @"";
                char *useremail = (char *)sqlite3_column_text(stmt, 5);
                if (useremail != NULL)
                     userInfo.emailAddress = [[NSString alloc] initWithUTF8String:useremail];
                else userInfo.emailAddress = @"";
                char *phone = (char *)sqlite3_column_text(stmt, 6);
                if (phone != NULL)
                    userInfo.phoneNo = [[NSString alloc] initWithUTF8String:phone];
                else
                    userInfo.phoneNo = @"";
            }
            sqlite3_close(database);
            if (userInfo.userNo==NULL) {
                return NO;
            }
            sqlite3_close(database);
            return YES;
        }
        sqlite3_close(database);
        return NO;
    }
    sqlite3_close(database);
    return NO;
}

+ (NSMutableArray *)getOtherUserInfo
{
    sqlite3_stmt *stmt;
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    NSString *createUserInfoTable = [NSString stringWithFormat:@"create table if not exists otheruserinfo(userno text primary key, username text, accounttype int, userphoto text, department text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    NSString *selectOtherUserInfo = @"select * from otheruserinfo";
    if (openResult) {
        [OperateDatabase execSql:createUserInfoTable];
        if (sqlite3_prepare_v2(database, [selectOtherUserInfo UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSMutableDictionary *theUser = [[NSMutableDictionary alloc] init];
                char *userno = (char *)sqlite3_column_text(stmt, 0);
                [theUser setObject:[[NSString alloc] initWithUTF8String:userno] forKey:@"userno"];
                char *username = (char *)sqlite3_column_text(stmt, 1);
                [theUser setObject:[[NSString alloc] initWithUTF8String:username] forKey:@"username"];
                char *userphoto = (char *)sqlite3_column_text(stmt, 3);
                if (userphoto != NULL)
                    [theUser setObject:[Base64 base64Decode:[[NSString alloc] initWithUTF8String:userphoto]] forKey:@"userphoto"];
                else [theUser setObject:@"" forKey:@"userphoto"];
                char *department = (char *)sqlite3_column_text(stmt, 4);
                if (department != NULL) {
                    [theUser setObject:[[NSString alloc] initWithUTF8String:department] forKey:@"department"];
                } else [theUser setObject:@"" forKey:@"department"];
                [retArray addObject:theUser];
            }
            sqlite3_close(database);
        }
        return retArray;
    }
    sqlite3_close(database);
    return retArray;
}

+ (NSMutableArray *)getOtherUserInfotoDelete
{
    sqlite3_stmt *stmt;
    UserInfomation *userInfo = [UserInfomation shareUserInfo];
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    NSString *createUserInfoTable = [NSString stringWithFormat:@"create table if not exists otheruserinfo(userno text primary key, username text, accounttype int, userphoto text, department text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    NSString *selectOtherUserInfo = [NSString stringWithFormat:@"select * from otheruserinfo where department = %@ and accounttype = 1", userInfo.department];
    if (openResult) {
        [OperateDatabase execSql:createUserInfoTable];
        if (sqlite3_prepare_v2(database, [selectOtherUserInfo UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSMutableDictionary *theUser = [[NSMutableDictionary alloc] init];
                char *userno = (char *)sqlite3_column_text(stmt, 0);
                [theUser setObject:[[NSString alloc] initWithUTF8String:userno] forKey:@"userno"];
                char *username = (char *)sqlite3_column_text(stmt, 1);
                [theUser setObject:[[NSString alloc] initWithUTF8String:username] forKey:@"username"];
                char *userphoto = (char *)sqlite3_column_text(stmt, 3);
                if (userphoto != NULL)
                    [theUser setObject:[Base64 base64Decode:[[NSString alloc] initWithUTF8String:userphoto]] forKey:@"userphoto"];
                else [theUser setObject:@"" forKey:@"userphoto"];
                char *department = (char *)sqlite3_column_text(stmt, 4);
                if (department != NULL) {
                    [theUser setObject:[[NSString alloc] initWithUTF8String:department] forKey:@"department"];
                } else [theUser setObject:@"" forKey:@"department"];
                [retArray addObject:theUser];
            }
            sqlite3_close(database);
        }
        return retArray;
    }
    sqlite3_close(database);
    return retArray;
}



+ (NSDictionary *)getPostFileContent
{
    sqlite3_stmt *stmt;
    NSMutableArray *fileover = [[NSMutableArray alloc] init];
    NSMutableArray *fileprogressing = [[NSMutableArray alloc] init];
    NSMutableArray *filenotpass = [[NSMutableArray alloc] init];
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists postfilecontent(department text, filestatus integer, posttime double primary key, filelabel text, filedetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        NSString *selectPostFile = [NSString stringWithFormat:@"select filestatus, posttime, filelabel from postfilecontent order by posttime desc"];
        if (sqlite3_prepare_v2(database, [selectPostFile UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                FileContent *postfile = [[FileContent alloc] init];
                int filestatus = sqlite3_column_int(stmt, 0);
                long posttime = sqlite3_column_double(stmt, 1);
                char *filelabel = (char *)sqlite3_column_text(stmt, 2);
                NSString *filelabelStr = [[NSString alloc] initWithUTF8String:filelabel];
                postfile.filelabel = filelabelStr;
                postfile.filestatus = filestatus;
                postfile.posttime = posttime;
                if (filestatus == 0)
                    [filenotpass addObject:postfile];
                if (filestatus == 1)
                    [fileprogressing addObject:postfile];
                if (filestatus == 2)
                    [fileover addObject:postfile];
            }
            [retDic setObject:filenotpass forKey:@"filenotpass"];
            [retDic setObject:fileprogressing forKey:@"fileprogress"];
            [retDic setObject:fileover forKey:@"fileover"];
        }
        sqlite3_close(database);
    }
    return retDic;
}

//发文管理的文件详情的时候查询数据库用到，根据发送时间获取文件详细内容
+ (FileContent *)getPostFileContent: (long)posttime
{
    sqlite3_stmt *stmt;
    FileContent *postfile = [[FileContent alloc] init];
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists postfilecontent(department text, filestatus integer, posttime double primary key, filelabel text, filedetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        NSString *selectPostFile = [NSString stringWithFormat:@"select * from postfilecontent where posttime = '%ld'",posttime];
        if (sqlite3_prepare_v2(database, [selectPostFile UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *department = (char *)sqlite3_column_text(stmt, 0);
                postfile.todepartment = [[NSString alloc] initWithUTF8String:department];
                postfile.filestatus = sqlite3_column_int(stmt, 1);
                postfile.posttime = sqlite3_column_double(stmt, 2);
                char *filelabel = (char *)sqlite3_column_text(stmt, 3);
                postfile.filelabel = [[NSString alloc] initWithUTF8String:filelabel];
                char *filedetail = (char *)sqlite3_column_text(stmt, 4);
                postfile.filedetail = [[NSString alloc] initWithUTF8String:filedetail];
            }
        }
        sqlite3_close(database);
    }
    return postfile;
}

+ (NSDictionary *)getReceiveFileContent
{
    sqlite3_stmt *stmt;
    NSMutableArray *receivefileArray = [[NSMutableArray alloc] init];

    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists receivefilecontent(username text, posttime double primary key, fromdepartment text, filelabel text, filedetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        NSString *selectPostFile = [NSString stringWithFormat:@"select username,fromdepartment, posttime, filelabel from receivefilecontent order by posttime desc"];
        if (sqlite3_prepare_v2(database, [selectPostFile UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                FileContent *receivefile = [[FileContent alloc] init];
                char *username = (char *)sqlite3_column_text(stmt, 0);
                NSString *usernameStr = [[NSString alloc] initWithUTF8String:username];
                char *fromdepartment = (char *)sqlite3_column_text(stmt, 1);
                NSString *fromdepartmentStr = [[NSString alloc] initWithUTF8String:fromdepartment];
                long posttime = sqlite3_column_double(stmt, 2);
                char *filelabel = (char *)sqlite3_column_text(stmt, 3);
                NSString *filelabelStr = [[NSString alloc] initWithUTF8String:filelabel];
                receivefile.username = usernameStr;
                receivefile.filelabel = filelabelStr;
                receivefile.fromdepartment = fromdepartmentStr;
                receivefile.posttime = posttime;
                [receivefileArray addObject:receivefile];
            }
            [retDic setObject:receivefileArray forKey:@"receivefiles"];
        }
        sqlite3_close(database);
    }
    return retDic;
}

//发文管理的文件详情的时候查询数据库用到，根据发送时间获取文件详细内容
+ (FileContent *)getReceiveFileContent: (long)posttime
{
    sqlite3_stmt *stmt;
    FileContent *receivefile = [[FileContent alloc] init];
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists receivefilecontent(username text, posttime double primary key,fromdepartment text, filelabel text, filedetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        NSString *selectPostFile = [NSString stringWithFormat:@"select * from receivefilecontent where posttime = '%ld'",posttime];
        if (sqlite3_prepare_v2(database, [selectPostFile UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *username = (char *)sqlite3_column_text(stmt, 0);
                receivefile.username = [[NSString alloc] initWithUTF8String:username];
                receivefile.posttime = sqlite3_column_double(stmt, 1);
                char *fromdepartment = (char *)sqlite3_column_text(stmt, 2);
                receivefile.fromdepartment = [[NSString alloc] initWithUTF8String:fromdepartment];
                char *filelabel = (char *)sqlite3_column_text(stmt, 3);
                receivefile.filelabel = [[NSString alloc] initWithUTF8String:filelabel];
                char *filedetail = (char *)sqlite3_column_text(stmt, 4);
                receivefile.filedetail = [[NSString alloc] initWithUTF8String:filedetail];
            }
        }
        sqlite3_close(database);
    }
    return receivefile;
}

+ (NSDictionary *)getAttachFileLabel
{
    sqlite3_stmt *stmt;
    NSMutableArray *officeFile = [[NSMutableArray alloc] init];
    NSMutableArray *imageFile = [[NSMutableArray alloc] init];
    NSMutableArray *videoFile = [[NSMutableArray alloc] init];
    NSMutableArray *pdfFile = [[NSMutableArray alloc] init];
   
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists attachfile(attachfiletype text, attachfilestatus int, attachfilelabel text primary key)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        NSString *selectPostFile = [NSString stringWithFormat:@"select attachfiletype, attachfilestatus, attachfilelabel from attachfile"];
        if (sqlite3_prepare_v2(database, [selectPostFile UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] init];
                
                char *attachfiletype = (char *)sqlite3_column_text(stmt, 0);
                NSString *type = [[NSString alloc] initWithUTF8String:attachfiletype];
                int attachfilestatus = sqlite3_column_int(stmt, 1);
                char *attachfilelabel = (char *)sqlite3_column_text(stmt, 2);
                NSString *filelabelStr = [[NSString alloc] initWithUTF8String:attachfilelabel];
                [fileDic setObject:[NSNumber numberWithInt:attachfilestatus] forKey:@"attachfilestatus"];
                [fileDic setObject:filelabelStr forKey:@"attachfilelabel"];
                if ([type isEqualToString:@"office"])
                    [officeFile addObject:fileDic];
                if ([type isEqualToString:@"image"])
                    [imageFile addObject:fileDic];
                if ([type isEqualToString:@"video"])
                    [videoFile addObject:fileDic];
                if ([type isEqualToString:@"pdf"])
                    [pdfFile addObject:fileDic];
            }
            [retDic setObject:officeFile forKey:@"office"];
            [retDic setObject:imageFile forKey:@"image"];
            [retDic setObject:videoFile forKey:@"video"];
            [retDic setObject:pdfFile forKey:@"pdf"];
        }
        sqlite3_close(database);
    }
    return retDic;
}

+ (NSMutableArray *)getChatlog:(NSString *)userno
{
    sqlite3_stmt *stmt;
    NSMutableArray *retArray= [[NSMutableArray alloc] init];

    NSString *createChatlogTable = [NSString stringWithFormat:@"create table if not exists chatlog(fromid text,toid text, chatdate double, chatdetail text, status int)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createChatlogTable];
        NSString *selectChatlog = [[NSString alloc] initWithFormat:@"select * from chatlog where (fromid = '%@' or toid = '%@') order by chatdate;",userno, userno];
        if (sqlite3_prepare_v2(database, [selectChatlog UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSMutableDictionary *chatDic = [[NSMutableDictionary alloc] init];
                char *fromid = (char *)sqlite3_column_text(stmt, 0);
                NSString *fromidStr = [[NSString alloc] init];
                if (fromid != NULL)
                    fromidStr = [[NSString alloc] initWithUTF8String:fromid];
                else
                    fromidStr = @"";
                char *toid = (char *)sqlite3_column_text(stmt, 1);
                NSString *toidStr = [[NSString alloc] init];
                if (toid != NULL)
                    toidStr = [[NSString alloc] initWithUTF8String:toid];
                else toidStr = @"";
                double chatDate = sqlite3_column_double(stmt, 2);
                NSString *chatdetailStr = [[NSString alloc] init];
                char *chatdetail = (char *)sqlite3_column_text(stmt, 3);
                if (chatdetail != NULL)
                    chatdetailStr = [[NSString alloc] initWithUTF8String:chatdetail];
                else chatdetailStr = @"";
                [chatDic setObject:[NSNumber numberWithDouble:chatDate] forKey:@"chatdate"];
                [chatDic setObject:chatdetailStr forKey:@"chatdetail"];
                if ([fromidStr isEqualToString:userno])
                    [chatDic setObject:@"someone" forKey:@"chattype"];
                if ([toidStr isEqualToString:userno])
                    [chatDic setObject:@"mine" forKey:@"chattype"];
                [retArray addObject:chatDic];
            }
        }
        sqlite3_close(database);
    }
    return retArray;
}

+ (BOOL)getChatIsUnRead: (NSString *)userno
{
    BOOL isHas = NO;
    sqlite3_stmt *stmt;
    NSString *createChatlogTable = [NSString stringWithFormat:@"create table if not exists chatlog(fromid text,toid text, chatdate double, chatdetail text, status int)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createChatlogTable];
        NSString *selectIsUnread = [[NSString alloc] initWithFormat:@"select fromid from chatlog where (fromid = '%@' and status = 0)", userno];
        if (sqlite3_prepare_v2(database, [selectIsUnread UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *fromid = (char *)sqlite3_column_text(stmt, 0);
                if (fromid != NULL) {
                    isHas = YES;
                }
            }
        }
        sqlite3_close(database);
    }
    return isHas;
}

+ (NSArray *)getActivityList
{
    sqlite3_stmt *stmt;
    NSMutableArray *activityListArray = [[NSMutableArray alloc] init];
    
    NSString *createActivityTable = [NSString stringWithFormat:@"create table if not exists activitylist(activitydate double primary key, activitydetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createActivityTable];
        NSString *selectActivityList = [NSString stringWithFormat:@"select * from activitylist order by activitydate desc"];
        if (sqlite3_prepare_v2(database, [selectActivityList UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSMutableDictionary *activity = [[NSMutableDictionary alloc] init];
                double date = (double)sqlite3_column_double(stmt, 0);
                char *detail = (char *)sqlite3_column_text(stmt, 1);
                NSString *detailStr = [[NSString alloc] initWithUTF8String:detail];
                [activity setObject:[NSNumber numberWithDouble:date] forKey:@"activitydate"];
                [activity setObject:detailStr forKey:@"activitydetail"];
                [activityListArray addObject:activity];
            }
        }
    }
    return activityListArray;
}

+ (void)InsertUserInfoToDatabase
{
    UserInfomation *userInfo = [UserInfomation shareUserInfo];
    sqlite3_stmt *stmt;
    NSString *createUserInfoTable = [NSString stringWithFormat:@"create table if not exists userinfo(userno text primary key, username text, userphoto text, accounttype integer, department text, emailaddress text, phone text)"];
    NSString *mainDatabasePath = [OperateDatabase getMainDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:mainDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createUserInfoTable];
        NSString *insertInfo = [NSString stringWithFormat:@"insert or replace into userinfo(userno,username,userphoto,accounttype,department,emailaddress,phone)" "values (?,?,?,?,?,?,?);"];
        if (sqlite3_prepare_v2(database, [insertInfo UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, [userInfo.userNo UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [userInfo.userName UTF8String], -1, NULL);
            NSString *photoStr = [Base64 base64Encode:userInfo.userPhoto];
            sqlite3_bind_text(stmt, 3,[photoStr UTF8String] , -1, NULL);
            sqlite3_bind_int(stmt, 4, userInfo.accountType);
            sqlite3_bind_text(stmt, 5, [userInfo.department UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 6, [userInfo.emailAddress UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 7, [userInfo.phoneNo UTF8String], -1, NULL);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);

}

+ (void)InsertOtherUserInfoToDatabase:(NSMutableArray *)allUserInfo
{
    sqlite3_stmt *stmt;
    NSString *createUserInfoTable = [NSString stringWithFormat:@"create table if not exists otheruserinfo(userno text primary key, username text, accounttype int, userphoto text, department text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createUserInfoTable];
        NSString *insertInfo = [NSString stringWithFormat:@"insert or replace into otheruserinfo(userno,username,accounttype, userphoto,department)" "values (?,?,?,?,?);"];
          for (int i=0; i<allUserInfo.count; i++) {
            if (sqlite3_prepare_v2(database, [insertInfo UTF8String], -1, &stmt, nil) == SQLITE_OK) {
                NSDictionary *theuserInfo = [[NSDictionary alloc] init];
                theuserInfo = [allUserInfo objectAtIndex:i];
                sqlite3_bind_text(stmt, 1, [[theuserInfo objectForKey:@"userno"] UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 2, [[theuserInfo objectForKey:@"username"] UTF8String], -1, NULL);
                sqlite3_bind_int(stmt, 3, [[theuserInfo objectForKey:@"accounttype"] intValue]);
                if ([theuserInfo objectForKey:@"userphoto"]!=NULL) {
                    NSString *photoStr = [theuserInfo objectForKey:@"userphoto"];
                    sqlite3_bind_text(stmt, 4,[photoStr UTF8String] , -1, NULL);
                }
                else sqlite3_bind_text(stmt, 4,[@"" UTF8String] , -1, NULL);

                if ([theuserInfo objectForKey:@"department"]!=NULL)
                    sqlite3_bind_text(stmt, 5, [[theuserInfo objectForKey:@"department"] UTF8String], -1, NULL);
                else
                    sqlite3_bind_text(stmt, 5, [@"" UTF8String], -1, NULL);
            }
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                
            }
        }
       
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    
}


+ (void)InsertPostFileContentToDatabase: (NSArray *)files
{
    sqlite3_stmt *stmt;
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists postfilecontent(department text, filestatus integer, posttime double primary key, filelabel text, filedetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        for (int i=0; i<[files count]; i++) {
            NSDictionary *file = [[NSDictionary alloc] init];
            file = [files objectAtIndex:i];
            NSString *insertFileContent = [NSString stringWithFormat:@"insert or replace into postfilecontent(department,filestatus,posttime,filelabel,filedetail)" "values (?,?,?,?,?);"];
            if (sqlite3_prepare_v2(database, [insertFileContent UTF8String], -1, &stmt, nil) == SQLITE_OK) {
                sqlite3_bind_text(stmt, 1, [[file objectForKey:@"department"] UTF8String], -1, NULL);
                sqlite3_bind_int(stmt, 2, [[file objectForKey:@"filestatus"] intValue]);
                sqlite3_bind_double(stmt, 3, [[file objectForKey:@"posttime"] intValue]);
                sqlite3_bind_text(stmt, 4, [[file objectForKey:@"filelabel"] UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 5, [[file objectForKey:@"filedetail"] UTF8String], -1, NULL);

            }
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                
            }
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

+ (void)InsertReceiveFileContentToDatabase: (NSArray *)files
{
    sqlite3_stmt *stmt;
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists receivefilecontent(username text, posttime double primary key, fromdepartment text filelabel text, filedetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        for (int i=0; i<[files count]; i++) {
            NSDictionary *file = [[NSDictionary alloc] init];
            file = [files objectAtIndex:i];
            NSString *insertFileContent = [NSString stringWithFormat:@"insert or replace into receivefilecontent(username,posttime,fromdepartment, filelabel,filedetail)" "values (?,?,?,?,?);"];
            if (sqlite3_prepare_v2(database, [insertFileContent UTF8String], -1, &stmt, nil) == SQLITE_OK) {
                sqlite3_bind_text(stmt, 1, [[file objectForKey:@"username"] UTF8String], -1, NULL);
                sqlite3_bind_double(stmt, 2, [[file objectForKey:@"posttime"] intValue]);
                sqlite3_bind_text(stmt, 3, [[file objectForKey:@"fromdepartment"] UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 4, [[file objectForKey:@"filelabel"] UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 5, [[file objectForKey:@"filedetail"] UTF8String], -1, NULL);
                
            }
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                
            }
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

+ (void)InsertAttachFileToDatabase: (NSArray *)attachfiles
{
    sqlite3_stmt *stmt;
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists attachfile(attachfiletype text, attachfilestatus int, attachfilelabel text primary key)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
       
        for (int i=0; i<[attachfiles count]; i++) {
            NSDictionary *file = [[NSDictionary alloc] init];
            file = [attachfiles objectAtIndex:i];
            NSString *insertFileContent = [NSString stringWithFormat:@"insert or replace into attachfile(attachfiletype, attachfilestatus, attachfilelabel)" "values (?,?,?);"];
            if (sqlite3_prepare_v2(database, [insertFileContent UTF8String], -1, &stmt, nil) == SQLITE_OK) {
                sqlite3_bind_text(stmt, 1, [[file objectForKey:@"attachfiletype"] UTF8String], -1, NULL);
                NSLog(@"%d",[[file objectForKey:@"attachfilestatus"] intValue]);
                sqlite3_bind_int(stmt, 2, [[file objectForKey:@"attachfilestatus"] intValue]);
                sqlite3_bind_text(stmt, 3, [[file objectForKey:@"attachfilelabel"] UTF8String], -1, NULL);
                
            }
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                
            }
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

+ (void)UpdateAttachFileToDatabase: (NSString *)attachfilename
{
    sqlite3_stmt *stmt;
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists attachfile(attachfiletype text, attachfilestatus int, attachfilelabel text primary key)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        NSString *insertFileContent = [NSString stringWithFormat:@"update attachfile set attachfilestatus = ? where attachfilelabel = ?;"];
        if (sqlite3_prepare_v2(database, [insertFileContent UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1, 1);
            sqlite3_bind_text(stmt, 2, [attachfilename UTF8String], -1, NULL);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

//聊天记录表 0代表未读，1代表已读
+ (void)InsertChatlogToDatabase: (NSDictionary *)chatDic
{
    sqlite3_stmt *stmt;
    NSString *createChatlogTable = [NSString stringWithFormat:@"create table if not exists chatlog(fromid text,toid text, chatdate double, chatdetail text, status int)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createChatlogTable];
        NSString *insertChatlog = [NSString stringWithFormat:@"insert into chatlog (fromid, toid, chatdate, chatdetail, status) values (?,?,?,?,?);"];
        if (sqlite3_prepare_v2(database, [insertChatlog UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, [[chatDic objectForKey:@"fromid"] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [[chatDic objectForKey:@"toid"] UTF8String], -1, NULL);
            sqlite3_bind_double(stmt, 3, [[chatDic objectForKey:@"msgdate"] doubleValue]);
            sqlite3_bind_text(stmt, 4, [[chatDic objectForKey:@"msgdetail"] UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 5, [[chatDic objectForKey:@"msgstatus"] intValue]);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

+ (void)updateChatlogStatus: (NSString *)fromID
{
    sqlite3_stmt *stmt;
    NSString *createFileContentTable = [NSString stringWithFormat:@"create table if not exists chatlog(fromid text,toid text, chatdate double, chatdetail text, status int)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createFileContentTable];
        NSString *updateChatLog = [[NSString alloc] initWithFormat:@"update chatlog set status = 1 where fromid = '%@' and status = 0", fromID];
        if (sqlite3_prepare_v2(database, [updateChatLog UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            
        }
    }
    sqlite3_close(database);

}

+ (void)InsertActivityList: (NSArray *)userList
{
    sqlite3_stmt *stmt;
    NSString *createActivityTable = [NSString stringWithFormat:@"create table if not exists activitylist(activitydate double primary key, activitydetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createActivityTable];
        NSString *insertActivityList = [NSString stringWithFormat:@"insert or replace into activitylist(activitydate, activitydetail) values (?,?)"];
        for (NSDictionary *activity in userList) {
            if (sqlite3_prepare(database, [insertActivityList UTF8String], -1, &stmt, nil) == SQLITE_OK) {
                sqlite3_bind_double(stmt, 1, [[activity objectForKey:@"date"] intValue]);
                sqlite3_bind_text(stmt, 2, [[activity objectForKey:@"detail"] UTF8String], -1, NULL);
            }
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                
            }
        }
    }
    sqlite3_close(database);
    
}

+ (void)DeleteActivityList:(double) activityDate
{
    sqlite3_stmt *stmt;
    NSString *createActivityTable = [NSString stringWithFormat:@"create table if not exists activitylist(activitydate double primary key, activitydetail text)"];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        [OperateDatabase execSql:createActivityTable];
        NSString *deleteActivityList = [NSString stringWithFormat:@"delete from activitylist where activitydate = %f",activityDate];
        if (sqlite3_prepare_v2(database, [deleteActivityList UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            
        }
    }
    sqlite3_close(database);

}

+ (void)deleteAllOldElement:(NSString *) tablename
{
    sqlite3_stmt *stmt;
    NSString *DeleteAllElement = [NSString stringWithFormat:@"delete from %@", tablename];
    NSString *userDatabasePath = [OperateDatabase getUserDatabasePath];
    BOOL openResult = [OperateDatabase OpenDatabase:userDatabasePath];
    if (openResult) {
        if (sqlite3_prepare_v2(database, [DeleteAllElement UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
        }
    }
    sqlite3_close(database);
}










@end
