//
//  RankCell.m
//  LoveAnchor
//
//  Created by NaNa on 14/12/12.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "RankCell.h"

@implementation RankCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataWithRankModel:(RankingModel *)rankModel
{
    if (rankModel.pic.length) {
        [_headImgView setImageWithURL:[NSURL URLWithString:rankModel.pic]];
    }
    if (rankModel.nick_name.length) {
        [_nickNameLab setText:rankModel.nick_name];
    }
    if (rankModel.coin_spend) {
        [_coinLab setText:[NSString stringWithFormat:@"%@金币",rankModel.coin_spend]];
    }
}

@end
