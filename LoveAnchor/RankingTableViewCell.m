//
//  RankingTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "RankingTableViewCell.h"

@implementation RankingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 5, 45, 45)];
        self.headImageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.headImageView.layer.borderWidth = 5.0;
        self.headImageView.layer.cornerRadius = 25.0;
        
        self.headImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headImageView];
        
        self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 30, 200, 18)];
        self.nickNameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nickNameLabel];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 18, 20, 20)];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.textColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.8];
        [self.contentView addSubview:self.numberLabel];
        
        self.firstImgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 20, 20)];
        self.firstImgView.image = [UIImage imageNamed:@"paihangbangdiyiming"];
        [self.contentView addSubview:self.firstImgView];
        
        self.crownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(98, 7, 16, 16)];
        [self.contentView addSubview:self.crownImageView];
        
        self.RoomNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 7, 80, 18)];
        self.RoomNumberLabel.textColor = [UIColor colorWithRed:205/255.0 green:35/255.0 blue:33/255.0 alpha:0.8];
        [self.contentView addSubview:self.RoomNumberLabel];
        
    }
    return self;
}

- (void)setCellData:(NSArray *)modelArray
{
    for (int i = 0; i < [modelArray count]; i++) {
        RankingModel *model = [modelArray objectAtIndex:i];
        [_headImageView setImageWithURL:[NSURL URLWithString:model.pic]];
        
        _nickNameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
        
        NSInteger coinNum = 0;
        NSInteger liveLevel = 0;
        NSInteger richLevel = 0;
        if (model.rankType == richType) {
            if ([model.finance objectForKey:@"coin_spend_total"]) {
                coinNum = [[model.finance objectForKey:@"coin_spend_total"] intValue];
                richLevel = [CommonUtil getLevelInfoWithCoin:coinNum isRich:YES].level;
                NSString *imageName = [NSString stringWithFormat:@"%ldfu",(long)richLevel];
                [_crownImageView setFrame:CGRectMake(94, 10, 25, 12)];
                [_crownImageView setImage:[UIImage imageNamed:imageName]];
            }
        } else {
            if ([model.finance objectForKey:@"bean_count_total"]) {
                coinNum = [[model.finance objectForKey:@"bean_count_total"] intValue];
                liveLevel = [CommonUtil getLevelInfoWithCoin:coinNum isRich:NO].level;
                NSString *imageName = [NSString stringWithFormat:@"%ldzhubo",(long)liveLevel];
                [_crownImageView setFrame:CGRectMake(98, 7, 16, 16)];
                [_crownImageView setImage:[UIImage imageNamed:imageName]];
            }
        }
        
        _RoomNumberLabel.text = [NSString stringWithFormat:@"%@",model._id];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
