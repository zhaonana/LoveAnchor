//
//  ThirdRowTableViewCell.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "ThirdRowTableViewCell.h"

@implementation ThirdRowTableViewCell

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
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*107, 0, 105, 81)];
        imageView2.backgroundColor = [UIColor clearColor];
        imageView2.userInteractionEnabled = YES;
        imageView2.tag = 10 + i;
        [self.contentView addSubview:imageView2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdTapClick:)];
        [imageView2 addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 48, 85, 15)];
        [nameLabel setShadowColor:[UIColor blackColor]];
        [nameLabel setShadowOffset:CGSizeMake(1, 1)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:11.0f];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.tag = 100 + i;
        [imageView2 addSubview:nameLabel];
        
        UIImageView *numberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 60, 16, 16)];
        numberImageView.tag = 500 + i;
        numberImageView.backgroundColor = [UIColor clearColor];
        [imageView2 addSubview:numberImageView];
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 60, 16)];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = [UIFont systemFontOfSize:12.0f];
        numberLabel.tag = 1000 + i;
        [numberLabel setShadowColor:[UIColor blackColor]];
        [numberLabel setShadowOffset:CGSizeMake(1, 1)];
        [imageView2 addSubview:numberLabel];
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
        [imageView setImageWithURL:[NSURL URLWithString:model.pic]];
        
        UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:100+i];
        nameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
        
        UILabel *numberLabel = (UILabel *)[self.contentView viewWithTag:1000+i];
        numberLabel.text = [NSString stringWithFormat:@"%@",model.visiter_count];
    }
}

- (void)thirdTapClick:(UIGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    if (tag - 10 < _modelArray.count) {
        RankingModel *model = _modelArray[tag-10];
        [self.delegate thirdClick:model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
