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
        self.headImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headImageView];
        
        self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 30, 200, 18)];
        self.nickNameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nickNameLabel];
        
        self.crownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 7, 16, 16)];
        [self.contentView addSubview:self.crownImageView];
        
        self.RoomNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 7, 80, 18)];
        self.RoomNumberLabel.textColor = [UIColor colorWithRed:205/255.0 green:35/255.0 blue:33/255.0 alpha:0.8];
        [self.contentView addSubview:self.RoomNumberLabel];
    }
    return self;
}

-(void)setCellData:(NSArray *)modelArray
{
    for (int i = 0; i < [modelArray count]; i++) {
        SearchModel *model = [modelArray objectAtIndex:i];
        
        [_headImageView setImageWithURL:[NSURL URLWithString:model.pic_url]];
        _nickNameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
        if ([model.finance objectForKey:@"bean_count_total"]) {
            NSInteger coinNum = [[model.finance objectForKey:@"bean_count_total"] intValue];
            NSInteger liveLevel = [CommonUtil getLevelInfoWithCoin:coinNum isRich:NO].level;
            NSString *imageName = [NSString stringWithFormat:@"%ldzhubo",(long)liveLevel];
            [_crownImageView setImage:[UIImage imageNamed:imageName]];
        }
        _RoomNumberLabel.text = [NSString stringWithFormat:@"%@",model._id];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
