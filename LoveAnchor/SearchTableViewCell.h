//
//  SearchTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-27.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//昵称
@property (nonatomic, strong) UILabel *nickNameLabel;
//皇冠
@property (nonatomic, strong) UIImageView *crownImageView;
//房间号
@property (nonatomic, strong) UILabel *RoomNumberLabel;

- (void)setCellData:(NSArray *)modelArray;

@end
