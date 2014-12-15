//
//  DynamicTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "DynamicTableViewCell.h"

@implementation DynamicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 45, 45)];
        self.headImageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.headImageView.layer.borderWidth = 5.0;
        self.headImageView.layer.cornerRadius = 25.0;
        [self.contentView addSubview:self.headImageView];
        
        self.nikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 200, 18)];
        self.nikeNameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nikeNameLabel];
        
        self.crownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(64, 7, 16, 16)];
        [self.contentView addSubview:self.crownImageView];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 6, 80, 18)];
        [self.contentView addSubview:self.numberLabel];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(274, 18, 20, 18);
        [self.deleteButton setImage:[UIImage imageNamed:@"qingchu"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

- (void)loadCellDataWithModel:(DynamicModel *)model;
{
    [_headImageView setImageWithURL:[NSURL URLWithString:model.pic]];
    _nikeNameLabel.text = [NSString stringWithFormat:@"%@",model.nickname];
    
    NSInteger level = [CommonUtil getLevelInfoWithCoin:model.bean_count_total.intValue isRich:NO].level;
    NSString *imageName = [NSString stringWithFormat:@"%dzhubo",level];
    [_crownImageView setImage:[UIImage imageNamed:imageName]];
    _numberLabel.text = [NSString stringWithFormat:@"%@",model.roomId];
}

- (void)deleteClick:(UIButton *)sender
{
    if (self.deleteButtonBlock) {
        self.deleteButtonBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
