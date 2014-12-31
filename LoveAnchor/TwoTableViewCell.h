//
//  TwoTableViewCell.h
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-10-16.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UISwitch *KGSwitth;
@property (nonatomic,strong)UIImageView *image2;
@property (nonatomic, copy) void (^switchClick)(BOOL isOn);

@end
