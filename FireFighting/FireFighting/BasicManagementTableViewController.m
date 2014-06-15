//
//  BasicManagementTableViewController.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-22.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "BasicManagementTableViewController.h"

@interface BasicManagementTableViewController ()
@property (strong, nonatomic) FileReceiveTableViewController *FRTableViewController;
@property (strong, nonatomic) FilePostViewController *FPViewController;
@property (strong, nonatomic) AttachFileDownloadTableViewController *AFDTableViewController;
@property (strong, nonatomic) PersionalActivityListViewController *PAViewController;
@property (strong, nonatomic) ControllerTableViewCell *controllerCell;

@property (strong, nonatomic) NSArray *controllerContentArray;

@end

static NSString *controllerCellIdentifiner = @"controllercell";


@implementation BasicManagementTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *ControllerCell_Nib = [UINib nibWithNibName:@"ControllerTableViewCell" bundle:nil];
    [self.tableView registerNib:ControllerCell_Nib forCellReuseIdentifier:controllerCellIdentifiner];
    _controllerContentArray = [[NSArray alloc] init];
    _controllerContentArray = [[FillControllerCellContent FillControllerCellContent] objectForKey:@"basiccontroller"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_controllerContentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:controllerCellIdentifiner forIndexPath:indexPath];
    cell.controllerImage.image = [UIImage imageNamed:[_controllerContentArray[indexPath.row] objectForKey:@"picture"]];
    cell.controllerName.text = [_controllerContentArray[indexPath.row] objectForKey:@"label"];
    cell.controllerName.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            _FPViewController = [[FilePostViewController alloc] initWithNibName:@"FilePostViewController" bundle:nil
                                 ];
            _FPViewController.navigationItem.title = @"发文管理";
            [self.navigationController pushViewController:_FPViewController animated:YES];
            break;
        case 1:
            _FRTableViewController = [[FileReceiveTableViewController alloc] initWithNibName:@"FileReceiveTableViewController" bundle:nil];
            _FRTableViewController.isReceiveFileView = YES;
            _FRTableViewController.navigationItem.title = @"收文管理";
            [self.navigationController pushViewController:_FRTableViewController animated:YES];
            break;
        case 2:
            _AFDTableViewController = [[AttachFileDownloadTableViewController alloc] initWithNibName:@"AttachFileDownloadTableViewController" bundle:nil];
            [self.navigationController pushViewController:_AFDTableViewController animated:YES];
            _AFDTableViewController.navigationItem.title = @"文件下载";
            break;
        case 3:
            _PAViewController = [[PersionalActivityListViewController alloc] init];
            _PAViewController.navigationItem.title = @"活动信息";
            [self.navigationController pushViewController:_PAViewController animated:YES];
        default:
            break;
    }
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
