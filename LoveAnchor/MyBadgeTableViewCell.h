//
//  MyBadgeTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 15-1-4.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBadgeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contenLab;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *DemandLabel;

@end
