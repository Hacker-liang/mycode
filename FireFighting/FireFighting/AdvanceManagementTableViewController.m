//
//  AdvanceManagementTableViewController.m
//  FireFighting
//
//  Created by liangpengshuai on 14-4-22.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "AdvanceManagementTableViewController.h"

@interface AdvanceManagementTableViewController ()
@property (strong, nonatomic) ControllerTableViewCell *controllerCell;

@end

@implementation AdvanceManagementTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    UINib *nib = [UINib nibWithNibName:@"ControllerTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"controllercell"];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"controllercell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.controllerImage.image = [UIImage imageNamed:@"checkfile.png"];
        cell.controllerName.text = @"审核文章";
    } else if(indexPath.row == 1) {
        cell.controllerImage.image = [UIImage imageNamed:@"adduser.png"];
        cell.controllerName.text = @"添加用户";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FileReceiveTableViewController *fileReceiveController= [[FileReceiveTableViewController alloc] init];
        fileReceiveController.isReceiveFileView = NO;
        fileReceiveController.navigationItem.title = @"审核文章";
        [self.navigationController pushViewController:fileReceiveController animated:YES];
    } else if (indexPath.row == 1) {
        AddUserTableViewController *addUserControlelr = [[AddUserTableViewController alloc] init];
        [self.navigationController pushViewController:addUserControlelr animated:YES];
    } else if (indexPath.row == 2) {
        
    }
}

@end
