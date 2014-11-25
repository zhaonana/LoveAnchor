//
//  SearchTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-27.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 45, 45)];
        self.headImageView.image = [UIImage imageNamed:@"touxiang1"];
        self.headImageView.tag = 100;
        self.headImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headImageView];
        
        self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 30, 200, 18)];
        self.nickNameLabel.text = @"心疼到爆也要强作欢笑ゞ";
        self.nickNameLabel.font = [UIFont systemFontOfSize:13];
        self.nickNameLabel.tag = 101;
        [self.contentView addSubview:self.nickNameLabel];
        
        self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 7, 18, 17)];
        self.rankLabel.text = @"12";
        self.rankLabel.tag = 102;
        self.rankLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.rankLabel];
        
        self.crownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(83, 7, 20, 17)];
        self.crownImageView.image = [UIImage imageNamed:@"huangguan"];
        [self.contentView addSubview:self.crownImageView];
        
        self.RoomNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 7, 80, 18)];
        self.RoomNumberLabel.text = @"(768687)";
        self.RoomNumberLabel.tag = 103;
        self.RoomNumberLabel.textColor = [UIColor colorWithRed:205/255.0 green:35/255.0 blue:33/255.0 alpha:0.8];
        [self.contentView addSubview:self.RoomNumberLabel];
    }
    return self;
}

-(void)setCellData:(NSArray *)modelArray
{
    for (int i = 0; i < [modelArray count]; i++) {
        SearchModel *model = [modelArray objectAtIndex:i];
        
        UIImageView *headImageView = (UIImageView *)[self.contentView viewWithTag:100];
        [headImageView setImageWithURL:[NSURL URLWithString:model.pic_url]];
        
        UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:101];
        nameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
        
        UILabel *rankLabel = (UILabel *)[self.contentView viewWithTag:102];
        rankLabel.text = [NSString stringWithFormat:@"%@",model.finance];
        
        UILabel *roomLabel = (UILabel *)[self.contentView viewWithTag:103];
        roomLabel.text = [NSString stringWithFormat:@"%@",model._id];
    }
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
