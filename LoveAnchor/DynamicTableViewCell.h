//
//  DynamicTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-26.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

@interface DynamicTableViewCell : UITableViewCell
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//昵称
@property (nonatomic, strong) UILabel     *nikeNameLabel;
//房间号
@property (nonatomic, strong) UILabel     *numberLabel;
//皇冠
@property (nonatomic, strong) UIImageView *crownImageView;
//删除
@property (nonatomic, strong) UIButton    *deleteButton;
//删除按钮block
@property (nonatomic, copy) void (^deleteButtonBlock)();

- (void)loadCellDataWithModel:(DynamicModel *)model;

@end
