//
//  SeatManageTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeatManageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *useButton;
@property (nonatomic, strong) UIButton *continueButton;

- (void)setCellData:(NSArray *)modelArray;

@end
