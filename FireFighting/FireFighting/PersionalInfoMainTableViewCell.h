//
//  PersionalInfoMainTableViewCell.h
//  FireFighting
//
//  Created by liang pengshuai on 14-4-23.
//  Copyright (c) 2014年 liang pengshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol SettingButtonPressDelegate
//
//- (void)EnterSettingDetailController;
//
//@end

@interface PersionalInfoMainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userNo;
@property (weak, nonatomic) IBOutlet UILabel *userType;
- (IBAction)SettingControl:(UIButton *)sender;

//@property (assign, nonatomic)id <SettingButtonPressDelegate>myDelegate;
@end
