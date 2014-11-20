//
//  TwoCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "TwoCell.h"

@implementation TwoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self showUI];
    }
    return self;
}

- (void)showUI
{
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 50, 15)];
    self.label1.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.label1];
    
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 150, 15)];
    self.label2.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.label2];
    
    self.NImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.NImageView];
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
