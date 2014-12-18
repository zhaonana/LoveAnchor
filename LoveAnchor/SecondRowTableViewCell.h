//
//  SecondRowTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"

@protocol SecondRowTableViewCellDelegate <NSObject>

- (void)secondClick:(RankingModel *)allModel;

@end

@interface SecondRowTableViewCell : UITableViewCell

@property (nonatomic,strong) id <SecondRowTableViewCellDelegate> delegate;
@property (nonatomic,strong)NSArray *modelArray;

- (void)setCellData:(NSArray *)modelArray;
@end
