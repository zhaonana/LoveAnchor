//
//  DynamicTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "DynamicTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DynamicModel.h"
#import "UIImageView+WebCache.h"

@implementation DynamicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 45, 45)];
        self.headImageView.image = [UIImage imageNamed:@"touxiang1"];
        self.headImageView.tag = 101;
        self.headImageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.headImageView.layer.borderWidth = 5.0;
        self.headImageView.layer.cornerRadius = 25.0;
        [self.contentView addSubview:self.headImageView];
        
        self.nikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 200, 18)];
        self.nikeNameLabel.text = @"心疼到爆也要强作欢笑ゞ";
        self.nikeNameLabel.tag = 102;
        self.nikeNameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nikeNameLabel];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 6, 80, 18)];
        self.numberLabel.text = @"(768687)";
        self.numberLabel.tag = 104;
        [self.contentView addSubview:self.numberLabel];
        
        self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 6, 37, 18)];
        self.rankLabel.text = @"12";
        self.rankLabel.tag = 103;
        self.rankLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.rankLabel];
        
        self.delegeteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.delegeteButton.frame = CGRectMake(274, 18, 20, 18);
        [self.delegeteButton setImage:[UIImage imageNamed:@"qingchu"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.delegeteButton];
    }
    return self;
}

- (void)setCellData:(NSArray *)modelArray
{
    for (int i = 0; i < [modelArray count]; i++) {
        DynamicModel *model = [modelArray objectAtIndex:i];
        
        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:101];
        [imageView setImageWithURL:[NSURL URLWithString:model.pic]];
        
        UILabel *nickLabel = (UILabel *)[self.contentView viewWithTag:102];
        nickLabel.text = [NSString stringWithFormat:@"%@",model.nickname];
        
        UILabel *rankingLabel = (UILabel *)[self.contentView viewWithTag:103];
        rankingLabel.text = [NSString stringWithFormat:@"%@",model.bean_count_total];
        
        UILabel *roomLabel = (UILabel *)[self.contentView viewWithTag:104];
        roomLabel.text = [NSString stringWithFormat:@"%@",model.roomId];
        
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
