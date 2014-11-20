//
//  ThirdRowTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllModel;

@protocol ThirdRowTableViewCellDelegate <NSObject>

- (void)thirdClick:(AllModel *)allModel;

@end

@interface ThirdRowTableViewCell : UITableViewCell

@property (nonatomic) id <ThirdRowTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSArray *modelArray;

- (void)setCellData:(NSArray *)modelArray;
@end
