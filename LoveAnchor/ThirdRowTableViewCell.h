//
//  ThirdRowTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-8-22.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThirdRowTableViewCellDelegate <NSObject>

- (void)thirdClick:(AllModel *)allModel;

@end

@interface ThirdRowTableViewCell : UITableViewCell

@property (nonatomic,strong) id <ThirdRowTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSArray *modelArray;

- (void)setCellData:(NSArray *)modelArray;
@end
