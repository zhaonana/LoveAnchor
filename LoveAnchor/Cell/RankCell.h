//
//  RankCell.h
//  LoveAnchor
//
//  Created by NaNa on 14/12/12.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel     *nickNameLab;
//财富等级
@property (weak, nonatomic) IBOutlet UIImageView *levelImgView;
//金币
@property (weak, nonatomic) IBOutlet UILabel     *coinLab;

- (void)loadDataWithRankModel:(RankingModel *)rankModel;

@end
