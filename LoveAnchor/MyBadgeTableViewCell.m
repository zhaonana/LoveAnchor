//
//  MyBadgeTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 15-1-5.
//  Copyright (c) 2015年 zhongqinglongtu. All rights reserved.
//

#import "MyBadgeTableViewCell.h"

@implementation MyBadgeTableViewCell

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
    self.badgeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
    [self.contentView addSubview:self.badgeImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 60, 15)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"一天不落";
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 5, 160, 15)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.text = @"(点亮后有效期：999天)";
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 270, 15)];
    self.introduceLabel.font = [UIFont systemFontOfSize:12];
    self.introduceLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    self.introduceLabel.numberOfLines = 0;
    self.introduceLabel.text = @"累计签到达100天";
    self.introduceLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.introduceLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 45, 100, 15)];
    self.moneyLabel.font = [UIFont systemFontOfSize:12];
    self.moneyLabel.text = @"金豆：0/90000";
    self.moneyLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.moneyLabel];
}
- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
