//
//  RankingTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "RankingTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "RankingModel.h"
#import "UIImageView+WebCache.h"
@implementation RankingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 5, 45, 45)];
        self.headImageView.image = [UIImage imageNamed:@"touxiang1"];
        self.headImageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.headImageView.layer.borderWidth = 5.0;
        self.headImageView.layer.cornerRadius = 25.0;
        self.headImageView.tag = 101;
        
        self.headImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headImageView];
        
        self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 30, 200, 18)];
        self.nickNameLabel.text = @"心疼到爆也要强作欢笑ゞ";
        self.nickNameLabel.font = [UIFont systemFontOfSize:13];
        self.nickNameLabel.tag = 102;
        [self.contentView addSubview:self.nickNameLabel];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 18, 20, 20)];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.8];
        [self.contentView addSubview:self.numberLabel];
        
        self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 7, 18, 17)];
        self.rankLabel.text = @"12";
        self.rankLabel.tag = 103;
        self.rankLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.rankLabel];
        
        self.crownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(113, 7, 20, 17)];
        self.crownImageView.image = [UIImage imageNamed:@"huangguan"];
        [self.contentView addSubview:self.crownImageView];
        
        self.RoomNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 7, 80, 18)];
        self.RoomNumberLabel.text = @"(768687)";
        self.RoomNumberLabel.tag = 104;
        self.RoomNumberLabel.textColor = [UIColor colorWithRed:205/255.0 green:35/255.0 blue:33/255.0 alpha:0.8];
        [self.contentView addSubview:self.RoomNumberLabel];
        
    }
    return self;
}

- (void)setCellData:(NSArray *)modelArray
{
    for (int i = 0; i < [modelArray count]; i++) {
        RankingModel *model = [modelArray objectAtIndex:i];
        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:101];
        [imageView setImageWithURL:[NSURL URLWithString:model.pic]];
        
        UILabel *nickLabel = (UILabel *)[self.contentView viewWithTag:102];
        nickLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
        
        UILabel *rankingLabel = (UILabel *)[self.contentView viewWithTag:103];
        rankingLabel.text = [NSString stringWithFormat:@"%@",model.finance];
        NSLog(@"model.finance = %@",model.finance);
        UILabel *roomLabel = (UILabel *)[self.contentView viewWithTag:104];
        roomLabel.text = [NSString stringWithFormat:@"%@",(model._id)];
        NSLog(@"model.star = %@",model.star);
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
