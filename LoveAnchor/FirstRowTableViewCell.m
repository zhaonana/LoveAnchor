//
//  FirstRowTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "FirstRowTableViewCell.h"

@implementation FirstRowTableViewCell

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
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 168)];
    logoImageView.backgroundColor = [UIColor clearColor];
    logoImageView.userInteractionEnabled = YES;
    logoImageView.tag = 100;
    [self.contentView addSubview:logoImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstTapClick:)];
    [logoImageView addGestureRecognizer:tap];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 150, 140, 15)];
    nameLabel.tag = 101;
    nameLabel.font = [UIFont systemFontOfSize:11.0f];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    [nameLabel setShadowColor:[UIColor blackColor]];
    [nameLabel setShadowOffset:CGSizeMake(1, 1)];
    [logoImageView addSubview:nameLabel];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(235, 150, 15, 15)];
    headImageView.tag = 500;
    headImageView.backgroundColor = [UIColor clearColor];
    [logoImageView addSubview:headImageView];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 150, 60, 16)];
    numberLabel.tag = 102;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:12.0f];
    numberLabel.backgroundColor = [UIColor clearColor];
    [numberLabel setShadowColor:[UIColor blackColor]];
    [numberLabel setShadowOffset:CGSizeMake(1, 1)];
    [logoImageView addSubview:numberLabel];
}

-(void)setCellData:(NSArray *)modelArray
{
    _modelArray = modelArray;
    RankingModel *model = [modelArray objectAtIndex:0];
    UIImageView *numberImageView = (UIImageView *)[self.contentView viewWithTag:500];
    numberImageView.image = [UIImage imageNamed:@"renshu"];
    
    UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:100];
    [imageView setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"aizhubo1"]];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:101];
    nameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
    
    UILabel *numberLabel = (UILabel *)[self.contentView viewWithTag:102];
    numberLabel.text = [NSString stringWithFormat:@"%@",model.visiter_count];
}

- (void)firstTapClick:(UIGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    if (tag - 100 < _modelArray.count) {
        RankingModel *model = _modelArray[tag-100];
        [self.delegate firstClick:model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
