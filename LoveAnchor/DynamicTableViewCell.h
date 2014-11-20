//
//  DynamicTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicTableViewCell : UITableViewCell
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//昵称
@property (nonatomic, strong) UILabel *nikeNameLabel;
//房间号
@property (nonatomic, strong) UILabel *numberLabel;
//等级
@property (nonatomic, strong) UILabel *rankLabel;
//皇冠
@property (nonatomic, strong) UIImageView *crownImageVIew;
//删除
@property (nonatomic, strong) UIButton *delegeteButton;

- (void)setCellData:(NSArray *)modelArray;

@end
