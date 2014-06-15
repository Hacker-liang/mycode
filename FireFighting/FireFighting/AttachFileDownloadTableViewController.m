//
//  AttachFileDownloadTableViewController.m
//  FireFighting
//
//  Created by liang pengshuai on 14-5-4.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "AttachFileDownloadTableViewController.h"

@interface AttachFileDownloadTableViewController ()
{
    NSMutableData *receiveData;
    UIView *topview;
    UIProgressView *progressView;
    NSString *attachfileLabel;
}
@property (nonatomic, strong) DownloadAttachFileHttpRequest *downloadAttachFileRequest;
@property (nonatomic, strong) UserInfomation *userInfo;
@property (nonatomic,strong) NSDictionary *attachFileDic;

@end

@implementation AttachFileDownloadTableViewController

static NSString *attachFileDownloadCell = @"attachfiledownloadcell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userInfo = [UserInfomation shareUserInfo];
    _attachFileDic = [[NSMutableDictionary alloc] init];
     _attachFileDic = [OperateDatabase getAttachFileLabel];
    [self loadnewFile];
    UINib *nib = [UINib nibWithNibName:@"AttachFileDownloadTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:attachFileDownloadCell];
    [self loadPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadPullToRefresh
{
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    __block AttachFileDownloadTableViewController *tempSelf = self;
    [self.tableView addCustomPullToRefreshWithActionHandler:^{
        [tempSelf loadnewFile];
    }];
}

- (void)loadnewFile
{
    [self.tableView.pullToRefreshView startAnimating];
    [self loadAttachFileFromNet];
}

- (void)loadAttachFileFromNet
{
    _downloadAttachFileRequest = [[DownloadAttachFileHttpRequest alloc] init];
    _downloadAttachFileRequest.myDelegate = self;
    [_downloadAttachFileRequest HttpAttachFilewithPost:[self encodeWithRefreshAttachFileFromNet]];
}

- (NSData *)encodeWithRefreshAttachFileFromNet
{
    NSData *retData = [[NSData alloc] init];
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"getattachfilelabel" forKey:@"attachfilerequest"];
    [requestDic setObject:_userInfo.department forKey:@"department"];
    retData = [OperateWithJson enCodeWithDictionary:requestDic];
    return retData;
}

- (NSData *)encodeWithDownloadAttachFileFromNet
{
    NSData *retData = [[NSData alloc] init];
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"downloadattachfile" forKey:@"attachfilerequest"];
    [requestDic setObject:attachfileLabel forKey:@"attachfilename"];
    retData = [OperateWithJson enCodeWithDictionary:requestDic];
    return retData;
}

- (NSArray *)updateAttachFileStatus:(NSArray *) attachfiles{
    NSArray *homeDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [homeDir objectAtIndex:0];
    NSString *attachfileDir = [documentDir stringByAppendingPathComponent:@"AttachFile"];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    if (![filemanager fileExistsAtPath:attachfileDir isDirectory:&isDir]) {
        [filemanager createDirectoryAtPath:attachfileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }else {
        NSArray *existFile = [filemanager subpathsAtPath:attachfileDir];
        for (int i=0; i<[attachfiles count]; i++){
            NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] init];
            fileDic = [[attachfiles objectAtIndex:i] mutableCopy];
            [retArray addObject:fileDic];
           for (NSString *filename in existFile) {
                BOOL isDownload = [filename isEqualToString:[fileDic objectForKey:@"attachfilelabel"]];
               if (isDownload) {
                   [fileDic setObject:[NSNumber numberWithInt:1] forKey:@"attachfilestatus"];
                   break;
               }
               
            }
        }
         NSLog(@"%@",retArray);
    }
   

    return retArray;
}

- (void)addAttachView
{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    topview = [[UIView alloc] initWithFrame:screenSize];
    topview.alpha = 0.95;
    UIView *attachView = [[UIView alloc] initWithFrame:CGRectMake((screenSize.size.width-200)/2, (screenSize.size.height-200)/2, 200, 200)];
    attachView.backgroundColor = [UIColor whiteColor];
    attachView.layer.borderWidth = 2;
    attachView.layer.borderColor = [[UIColor blueColor] CGColor];
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 140, 160, 80)];
    progressView.progress = 0;
    [attachView addSubview:progressView];
    UILabel *fileName = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 160, 15)];
    fileName.text = [NSString stringWithFormat:@"正在下载:%@",attachfileLabel];
    fileName.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    fileName.textAlignment = NSTextAlignmentCenter;
    attachView.layer.cornerRadius = 10;
    [attachView addSubview:fileName];
    UIImage *attachimage = [UIImage imageNamed:@"attachviewimage.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(62, 50, 76, 76)];
    imageView.image = attachimage;
    [attachView addSubview:imageView];
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];  // 创建按钮
    [cancleBtn setFrame :CGRectMake(50, 170, 100, 20)];
    [cancleBtn addTarget:self action:@selector(cancleDownload) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消下载" forState:UIControlStateNormal];   // 设置风格
    [attachView addSubview:cancleBtn];
    [topview addSubview:attachView];
    [self.view addSubview:topview];
    //将tableview滚动到顶部
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
     self.tableView.scrollEnabled = NO;
}

- (void)cancleDownload
{
    [_downloadAttachFileRequest cancleDownload];
    [topview removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [[_attachFileDic objectForKey:@"office"] count];
            break;
        case 1:
            return [[_attachFileDic objectForKey:@"image"] count];
            break;
        case 2:
            return [[_attachFileDic objectForKey:@"video"] count];
            break;
        case 3:
            return [[_attachFileDic objectForKey:@"pdf"] count];
            break;
        default:
            return 0;
            break;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"文档";
            break;
        case 1:
            return @"照片";
            break;
        case 2:
            return @"视频";
            break;
        case 3:
            return @"PDF";
            break;
            
        default:
            return nil;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *attachfile = [[NSDictionary alloc] init];
    AttachFileDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attachFileDownloadCell forIndexPath:indexPath];
    cell.myDelegate = self;
    switch (indexPath.section) {
        case 0:
            attachfile = [[_attachFileDic objectForKey:@"office"] objectAtIndex:indexPath.row];
            cell.attachFileImage.image = [UIImage imageNamed:@"attachfileoffice.png"];
            break;
        case 1:
            attachfile = [[_attachFileDic objectForKey:@"image"] objectAtIndex:indexPath.row];
            cell.attachFileImage.image = [UIImage imageNamed:@"attachfileimage.png"];
            break;
        case 2:
            attachfile = [[_attachFileDic objectForKey:@"video"] objectAtIndex:indexPath.row];
            cell.attachFileImage.image = [UIImage imageNamed:@"attachfilevideo.png"];
            break;
        case 3:
            attachfile = [[_attachFileDic objectForKey:@"pdf"] objectAtIndex:indexPath.row];
            cell.attachFileImage.image = [UIImage imageNamed:@"attachfilepdf.png"];
            break;
        default:
            break;
    }
    cell.attachFilelabel.text = [attachfile objectForKey:@"attachfilelabel"];
    if ([[attachfile objectForKey:@"attachfilestatus"] intValue] == 0) {
        cell.isDownloadBtn.hidden = YES;
        cell.downloadBtn.hidden = NO;
    }else {
        cell.isDownloadBtn.hidden = NO;
        cell.downloadBtn.hidden = YES;
    }
    cell.attachFileName = [attachfile objectForKey:@"attachfilelabel"];
    return cell;
}

#pragma mark- DownLoadAttachFileHttpRequestDelegate
- (void)DoWithAttachFileHttpResulat:(NSData *)resulatData
{
    NSDictionary *retDic = [[NSDictionary alloc] init];
    retDic = [OperateWithJson deCodewithJSON:resulatData];
    if ([[retDic objectForKey:@"attachfileresult"] isEqualToString:@"attachfilelabel"]) {
        [OperateDatabase deleteAllOldElement:@"attachfile"];
        if ([[retDic objectForKey:@"attachfilelabel"] count] != 0) {
            [OperateDatabase InsertAttachFileToDatabase:[self updateAttachFileStatus:[retDic objectForKey:@"attachfilelabel"]]];
        }
        _attachFileDic = [OperateDatabase getAttachFileLabel];
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
        
    }else if ([[retDic objectForKey:@"attachfileresult"] isEqualToString:@"attachfilecontent"]) {
        if ([[[retDic objectForKey:@"attachfilecontent"]objectForKey:@"downloadattachfile"]boolValue]) {
            [self removeAttachView:YES];
            [OperateWithFile WriteDataToSandbox:[[retDic objectForKey:@"attachfilecontent"]objectForKey:@"content"] fileName:attachfileLabel];
            [OperateDatabase UpdateAttachFileToDatabase:attachfileLabel];
            _attachFileDic = [OperateDatabase getAttachFileLabel];
            [self.tableView reloadData];
        } else {
            [self removeAttachView:NO];
        }
        
    }
}

- (void)updateProgress:(double)progress
{
    progressView.progress = progress;
    
}

- (void)removeAttachView:(BOOL)isSucess
{
    [topview removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIAlertView *alert;
    if (isSucess)
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"下载成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预览", nil];
    else alert = [[UIAlertView alloc] initWithTitle:@"" message:@"下载失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alert show];
}

#pragma mark - AttachFileDownloadDelegate

- (void)DownloadAttachfile:(NSString *)fileName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定下载%@?",fileName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是的", nil];
    attachfileLabel = fileName;
    [alert show];
}

- (void)PreviewAttachfile:(NSString *)fileName
{
    attachfileLabel = fileName;
    QLPreviewController *previewer = [[QLPreviewController alloc] init];
	[previewer setDataSource:self];
    
	[[self navigationController] pushViewController:previewer animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"预览"]) {
            QLPreviewController *previewer = [[QLPreviewController alloc] init];
            [previewer setDataSource:self];
            
            [[self navigationController] pushViewController:previewer animated:YES];

        }if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"是的"]) {
            [self addAttachView];
            if (!_downloadAttachFileRequest) {
                _downloadAttachFileRequest = [[DownloadAttachFileHttpRequest alloc] init];
            }
            [_downloadAttachFileRequest HttpAttachFilewithPost:[self encodeWithDownloadAttachFileFromNet]];
            
        }if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"重试"]) {
            _downloadAttachFileRequest = [[DownloadAttachFileHttpRequest alloc] init];
            _downloadAttachFileRequest.myDelegate = self;
            [_downloadAttachFileRequest HttpAttachFilewithPost:[self encodeWithDownloadAttachFileFromNet]];
            [self addAttachView];
        }
    }
}


#pragma mark - QLPreviewControllerDataSource Delegate

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
	return 1;
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [array objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [NSString stringWithFormat:@"%@/AttachFile/%@",dir,attachfileLabel];
    BOOL result = [fileManager fileExistsAtPath:path];
    if (result) {
        return [NSURL fileURLWithPath:path];
    }
	return nil;
}

@end






