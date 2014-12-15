//
//  RankingTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingTableViewCell : UITableViewCell
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//昵称
@property (nonatomic, strong) UILabel     *nickNameLabel;
//编号
@property (nonatomic, strong) UILabel     *numberLabel;
//皇冠
@property (nonatomic, strong) UIImageView *crownImageView;
//房间号
@property (nonatomic, strong) UILabel     *RoomNumberLabel;
//第一个
@property (nonatomic, strong) UIImageView *firstImgView;

- (void)setCellData:(NSArray *)modelArray;


@end
