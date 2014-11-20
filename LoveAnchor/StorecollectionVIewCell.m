//
//  StorecollectionVIewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-14.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "StorecollectionVIewCell.h"

@implementation StorecollectionVIewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
    }
    return self;
}

#pragma mark - ccollectionView
- (void)showUI
{
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 55)];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.bgImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 75, 20)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.bgImageView addSubview:self.titleLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 75, 20)];
    self.moneyLabel.backgroundColor = [UIColor clearColor];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = [UIFont systemFontOfSize:12];
    [self.bgImageView addSubview:self.moneyLabel];
    
}
@end
