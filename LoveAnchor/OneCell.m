//
//  OneCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-18.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "OneCell.h"

@implementation OneCell

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
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7, 40, 40)];
    self.headImage.image =[UIImage imageNamed:@"touxiang1"];
    [self.contentView addSubview:self.headImage];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 10)];
    self.titleLabel.text = @"花开那时又逢君求包养";
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.titleLabel];
    
    self.IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 22, 100, 10)];
    self.IDLabel.font = [UIFont systemFontOfSize:10];
    self.IDLabel.text = [NSString stringWithFormat:@"ID:%d",12080546];
    [self.contentView addSubview:self.IDLabel];
    
    self.HGimageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 33, 15, 15)];
    self.HGimageView.image = [UIImage imageNamed:@"shoucang"];
    [self.contentView addSubview:self.HGimageView];
    
    self.DJimageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 35, 25, 12)];
    self.DJimageView.image = [UIImage imageNamed:@"2fu"];
    [self.contentView addSubview:self.DJimageView];
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
