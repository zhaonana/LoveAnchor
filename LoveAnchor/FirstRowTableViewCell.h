//
//  FirstRowTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllModel;
@protocol FirstRowTableViewCellDelegate <NSObject>

- (void)firstClick:(AllModel *)allModel;

@end

@interface FirstRowTableViewCell : UITableViewCell

@property (nonatomic,weak) id <FirstRowTableViewCellDelegate> delegate;
@property (nonatomic,strong)NSArray *modelArray;


- (void)setCellData:(NSArray *)modelArray;
@end
