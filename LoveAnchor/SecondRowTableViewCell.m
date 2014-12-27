//
//  SecondRowTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "SecondRowTableViewCell.h"

@implementation SecondRowTableViewCell

- (id)init
{
    if (self == [super init]) {
        [self showUI];
    }
    return self;
}

#pragma mark - 界面
- (void)showUI
{
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*161, 0, 159, 120)];
        imageView1.backgroundColor = [UIColor clearColor];
        imageView1.tag = 10+i;
        imageView1.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondTapClick:)];
        [imageView1 addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 90, 110, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:11.0f];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.tag = 100+i;
        [nameLabel setShadowColor:[UIColor blackColor]];
        [nameLabel setShadowOffset:CGSizeMake(1, 1)];
        [imageView1 addSubview:nameLabel];
        
        UIImageView *numberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 105, 15, 15)];
        numberImageView.tag = 500 + i;
        numberImageView.backgroundColor = [UIColor clearColor];
        [imageView1 addSubview:numberImageView];
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 105, 130, 16)];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = [UIFont systemFontOfSize:12.0f];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.tag = 1000+i;
        [numberLabel setShadowColor:[UIColor blackColor]];
        [numberLabel setShadowOffset:CGSizeMake(1, 1)];
        [imageView1 addSubview:numberLabel];
    }
}

- (void)setCellData:(NSArray *)modelArray
{
    _modelArray = modelArray;
    for (int i = 0; i < [modelArray count]; i++) {
        RankingModel *model = [modelArray objectAtIndex:i];
        UIImageView *numberImageView = (UIImageView *)[self.contentView viewWithTag:500+i];
        numberImageView.image = [UIImage imageNamed:@"renshu"];

        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:10+i];
        [imageView setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"aizhubo2"]];

        UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:100+i];
        nameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
        
        UILabel *numberLabel = (UILabel *)[self.contentView viewWithTag:1000+i];
        numberLabel.text = [NSString stringWithFormat:@"%@",model.visiter_count];
    }
}
- (void)secondTapClick:(UITapGestureRecognizer *)sender
{
    NSInteger tag = sender.view.tag;
    if (tag - 10 < _modelArray.count) {
        RankingModel *model = _modelArray[tag-10];
        [self.delegate secondClick:model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
