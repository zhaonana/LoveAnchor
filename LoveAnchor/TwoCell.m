//
//  TwoCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "TwoCell.h"

@implementation TwoCell

- (id)init
{
    self = [super init];
    if (self) {
        [self showUI];
    }
    return self;
}

- (void)showUI
{
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 50, 15)];
    _titleLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_titleLab];
    
    _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 240, 15)];
    _contentLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_contentLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
