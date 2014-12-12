//
//  RankCell.h
//  LoveAnchor
//
//  Created by NaNa on 14/12/12.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel     *nickNameLab;

- (void)loadDataWithRankModel:(RankingModel *)rankModel;

@end
