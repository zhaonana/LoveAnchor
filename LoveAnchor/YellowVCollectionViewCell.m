//
//  YellowVCollectionViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-7.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "YellowVCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation YellowVCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
    }
    return self;
}

- (void)showUI
{
    self.bagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 0.5, 140, 44)];
    self.bagImageView.layer.borderColor = [UIColor purpleColor].CGColor;
    self.bagImageView.layer.borderWidth = 0.2;
    self.bagImageView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.bagImageView];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 80, 15)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.bagImageView addSubview:self.timeLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 80, 15)];
    self.moneyLabel.backgroundColor = [UIColor clearColor];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = [UIFont systemFontOfSize:10];
    [self.bagImageView addSubview:self.moneyLabel];
}

@end
