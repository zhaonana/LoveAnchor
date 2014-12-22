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
    if (rankModel.pic_url.length) {
        [_headImgView setImageWithURL:[NSURL URLWithString:rankModel.pic_url]];
    }
    if (rankModel.nick_name.length) {
        [_nickNameLab setText:rankModel.nick_name];
    }
    if (rankModel.coin_spend) {
        [_coinLab setText:[NSString stringWithFormat:@"%@金币",rankModel.coin_spend]];
    }
    if (rankModel.coin_spend_total) {
        NSInteger level = [CommonUtil getLevelInfoWithCoin:rankModel.coin_spend_total.intValue isRich:YES].level;
        [_levelImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dfu",level]]];
    }
}

@end
