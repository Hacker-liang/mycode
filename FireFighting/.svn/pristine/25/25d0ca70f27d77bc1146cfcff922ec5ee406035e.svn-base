//
//  ChatViewController.m
//  FireFighting
//
//  Created by liang pengshuai on 14-3-17.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
{
    float currentKeyboardHeigh;
    BOOL keyboardIsShow;
    float bubbleViewFrame;
}
@property (strong, nonatomic) SocketServer *socketServer;
@property (strong, nonatomic) NSMutableArray *chatlogArray;
@property (strong, nonatomic) NSMutableArray *cellArray;
@property (strong, nonatomic) UserInfomation *userInfo;

@property (nonatomic) CGSize keyboardSize;


@end

@implementation ChatViewController

static NSString *messageCellIdentifier = @"messageCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     keyboardIsShow = NO;
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    _bubbleTable.bubbleDataSource = self;
    _bubbleTable.showAvatars = YES;
  //  _bubbleTable.snapInterval = 120;

    _socketServer = [SocketServer shareSocketServer];
    if (!_cellArray) {
        _cellArray = [[NSMutableArray alloc]init];
    }
    _messageToSend.layer.cornerRadius = 3.0f;
    _messageToSend.delegate = self;
    _userInfo = [UserInfomation shareUserInfo];
    _chatlogArray = [[NSMutableArray alloc] init];
    _chatlogArray = [OperateDatabase getChatlog:_otherUserID];
    for (NSDictionary *dic in _chatlogArray) {
        NSBubbleData *chatData;
        if ([[dic objectForKey:@"chattype"] isEqualToString:@"someone"]) {
            NSDate *chatdate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"chatdate"] doubleValue]-8*3600];

            chatData = [[NSBubbleData alloc] initWithText:[dic objectForKey:@"chatdetail"] date:chatdate type:BubbleTypeSomeoneElse];
            chatData.avatar = _otherImage;

        } else {
            NSDate *chatdate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"chatdate"] doubleValue]-8*3600];
            
            chatData = [[NSBubbleData alloc] initWithText:[dic objectForKey:@"chatdetail"] date:chatdate type:BubbleTypeMine];
            chatData.avatar = _myImage;
        }
        
        [_cellArray addObject:chatData];
        
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = _chatWith;
    [super viewWillAppear:animated];
    [OperateDatabase updateChatlogStatus:_otherUserID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide :) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow :) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChatView:) name:@"updateChatView" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateChatView" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_cellArray.count>0) {
        if ((int)[_cellArray objectAtIndex:(_cellArray.count-1)] > 380) {
            [self.bubbleTable scrollBubbleViewToBottomAnimated:NO];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)updateChatView:(NSNotification *)noti
{
    if ([[noti.object objectForKey:@"fromid"] isEqualToString:_otherUserID]) {
        [OperateDatabase updateChatlogStatus:_otherUserID];
        NSBubbleData *bubbleData = [NSBubbleData dataWithText:[noti.object objectForKey:@"msgdetail"] date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
        bubbleData.avatar = _otherImage;
        [_cellArray addObject:bubbleData];
        [_bubbleTable reloadData];
        if ((int)bubbleData > 380) {
            [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
        }
    }
    
}

- (void)TouchDownViewToHideKeyboard
{
    [_messageToSend resignFirstResponder];
}


#pragma -UIBubbleTableViewDataSource

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [_cellArray count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_cellArray objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)KeyboardWillShow :(NSNotification*)aNotification
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchDownViewToHideKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self.bubbleTable addGestureRecognizer:tap];
    
    CGRect windowSize = [[UIScreen mainScreen] bounds];
    float kbEndHeigh = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    float kbBeginHeigh = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size.height;
    float kbBeginY = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].origin.y;
    
    if (kbBeginY == windowSize.size.height) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = _textView.frame;
            frame.origin.y -= kbEndHeigh;
            _textView.frame = frame;
        }];
    } else if(kbBeginHeigh < kbEndHeigh) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = _textView.frame;
            frame.origin.y -= (kbEndHeigh - kbBeginHeigh);
            _textView.frame = frame;
        }];
    } else if(kbBeginHeigh > kbEndHeigh) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = _textView.frame;
            frame.origin.y += (kbBeginHeigh - kbEndHeigh);
            _textView.frame = frame;
        }];
    }

}

- (void)KeyboardWillHide:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //通过传递通知类型，得到键盘的大小。
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = _textView.frame;
            frame.origin.y += kbSize.height;
            _textView.frame = frame;
        }];
}

- (void)SendMessage
{
    if (_socketServer.isConnected) {
        if (![_messageToSend.text isEqual: @""]) {
            NSMutableDictionary *insertToDBdic = [[NSMutableDictionary alloc] init];
            [insertToDBdic setObject:_otherUserID forKey:@"toid"];
            [insertToDBdic setObject:_messageToSend.text forKey:@"msgdetail"];
            [insertToDBdic setObject:[NSNumber numberWithInt:1] forKey:@"msgstatus"];
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate: date];
            NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
            NSInteger intervalfrom1970 = [localeDate timeIntervalSince1970];
            [insertToDBdic setObject:[NSNumber numberWithDouble:intervalfrom1970] forKey:@"msgdate"];
            [OperateDatabase InsertChatlogToDatabase:insertToDBdic];
            [_socketServer WriteDataToServer:[self encodeWithInput:_messageToSend.text]];
            NSBubbleData *bubbleData = [NSBubbleData dataWithText:_messageToSend.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
            bubbleData.avatar = _myImage;
            [_cellArray addObject:bubbleData];
            [_bubbleTable reloadData];
            [_messageToSend setText:@""];
            [_messageToSend resignFirstResponder];
            bubbleViewFrame += bubbleData.view.frame.size.height;
            [PlayRadio playSound:@"send"];
            if ((int)bubbleData > 380) {
                [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSData *)encodeWithInput:(NSString *)msgDetail
{
    NSData *retData = [[NSData alloc] init];
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *MsgDic = [[NSMutableDictionary alloc] init];
    [MsgDic setObject:_userInfo.userNo forKey:@"fromid"];
    [MsgDic setObject:_otherUserID forKey:@"toid"];
    [MsgDic setObject:msgDetail forKey:@"msgdetail"];
    [requestDic setObject:@"newmsg" forKey:@"cmd"];
    [requestDic setObject:MsgDic forKey:@"msgcontent"];
    retData = [OperateWithJson enCodeWithDictionary:requestDic];
    return retData;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [self SendMessage];
        return NO;
    }
    return YES;
}

@end










