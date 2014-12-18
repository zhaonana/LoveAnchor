//
//  FirstRowTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"

@protocol FirstRowTableViewCellDelegate <NSObject>

- (void)firstClick:(RankingModel *)allModel;

@end

@interface FirstRowTableViewCell : UITableViewCell

@property (nonatomic,weak) id <FirstRowTableViewCellDelegate> delegate;
@property (nonatomic,strong)NSArray *modelArray;


- (void)setCellData:(NSArray *)modelArray;
@end
