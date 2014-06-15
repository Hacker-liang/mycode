//
//  PersionalInfoMainTableViewCell.m
//  FireFighting
//
//  Created by liang pengshuai on 14-4-23.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import "PersionalInfoMainTableViewCell.h"

@implementation PersionalInfoMainTableViewCell

- (void)awakeFromNib
{
    _userImage.image = [UIImage imageNamed:@"hehe.png"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)SettingControl:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterSettingDetailController" object:nil];
}
@end
